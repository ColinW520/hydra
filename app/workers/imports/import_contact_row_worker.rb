class Imports::ImportContactRowWorker
  include Sidekiq::Worker
  sidekiq_options queue: :imports

  def perform(row, import_id)
    row = row.with_indifferent_access
    @retry_count ||= 0
    the_import = Import.find import_id
    the_organization = Organization.find the_import.organization_id

    # dont bother if there is no number.
    return unless row[:phone].present?

    # find or init the contact by the organization and the phone number, properly normalized
    contact = Contact.where(organization_id: the_organization.id, mobile_phone: PhonyRails.normalize_number(row[:phone], country_code: 'US')).first_or_initialize

    contact.organization_id = the_import.organization_id
    contact.first_name = row[:first_name]
    contact.last_name = row[:last_name]
    contact.mobile_phone = PhonyRails.normalize_number(row[:phone], country_code: 'US')

    contact.title = row[:title] if row[:title].present?
    contact.address_city = row[:city] if row[:city].present?
    contact.address_state = row[:state] if row[:state].present?
    contact.address_zip = row[:zip] if row[:zip].present?
    contact.is_active = row[:is_active] ||= true
    contact.internal_identifier = row[:internal_identifier] if row[:internal_identifier].present?

    contact.tag_list = row[:tags].split('|').compact.reject(&:blank?).uniq.join(', ') if row[:tag_list].present?

    contact.removed_at = nil
    contact.removed_by = nil

    contact.save!
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique
    if (@retry_count += 1) <= 2
      retry
    else
      raise
    end
  end
end
