class Imports::ImportContactRowWorker
  include Sidekiq::Worker
  sidekiq_options queue: :imports

  def perform(result_id)
    # set the required objects up
    @the_result = ImportResult.find result_id
    @the_import = @the_result.import
    @the_row = @the_result.row_data.with_indifferent_access

    # now start processing
    @the_result.update_attribute(:status, 'processing')
    @retry_count ||= 0

    # first check for a phone number.
    return @the_result.update_attributes(
      result: 'failure',
      status: 'complete',
      message: 'The value for phone is not present.'
    ) if !@the_row[:phone].present?

    # now check and make sure that it is a valid phone number
    return @the_result.update_attributes(
      result: 'failure',
      status: 'complete',
      message: 'It appears this is not a valid US phone number.'
    ) if @the_row[:phone].phony_formatted(normalize: 'US', strict: true).nil?

    # find or init the contact by the organization and the phone number, properly normalized
    @the_contact = Contact.where(
      organization_id: @the_import.organization_id,
      mobile_phone: PhonyRails.normalize_number(@the_row[:phone],country_code: 'US')
    ).first_or_initialize

    @the_contact.organization_id = @the_import.organization_id
    @the_contact.first_name = @the_row[:first_name]
    @the_contact.last_name = @the_row[:last_name]
    @the_contact.mobile_phone = PhonyRails.normalize_number(@the_row[:phone], country_code: 'US')
    @the_contact.title = @the_row[:title] if @the_row[:title].present?
    @the_contact.address_city = @the_row[:city] if @the_row[:city].present?
    @the_contact.address_state = @the_row[:state] if @the_row[:state].present?
    @the_contact.address_zip = @the_row[:zip] if @the_row[:zip].present?
    # is this an existing contact that is
    # @the_contact.is_active = @the_row[:is_active] ||= false
    @the_contact.internal_identifier = @the_row[:internal_identifier] if @the_row[:internal_identifier].present?

    @the_contact.tag_list = @the_row[:tags].split('|').compact.reject(&:blank?).uniq.join(', ') if @the_row[:tags].present?

    @the_contact.removed_at = nil
    @the_contact.removed_by = nil

    if @the_contact.persisted?
      @the_result.message = 'The contact was updated with the given values.'
    else
      @the_result.message = 'A contact was created with the given values.'
    end

    # save the contact (persists the record)
    @the_contact.save!

    # finalize the result
    @the_result.status = 'complete'
    @the_result.result = 'success'
    @the_result.save!

  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique => error
    if (@retry_count += 1) <= 2
      retry
    else
      @the_result.update_attributes(status: 'complete',result: 'failure',message: error.message)
    end
  end
end
