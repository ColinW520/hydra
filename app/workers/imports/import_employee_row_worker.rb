class Imports::ImportcontactRowWorker
  include Sidekiq::Worker

  def perform(row, import_id)
    row = row.with_indifferent_access
    @retry_count ||= 0
    the_import = Import.find import_id
    the_organization = Organization.find the_import.organization_id

    contact = contact.where(organization_id: the_organization.id, mobile_phone: row[:phone]).first_or_initialize

    contact.organization_id = the_import.organization_id
    contact.first_name = row[:first_name]
    contact.last_name = row[:last_name]
    contact.email = row[:email]
    contact.mobile_phone = row[:phone].gsub(/\D/, '')

    contact.title = row[:title]
    contact.address_city = row[:city]
    contact.address_state = row[:state]
    contact.address_zip = row[:zip]
    contact.started_at = Date.strptime row[:started_at], '%m/%d/%Y'
    contact.birthday = Date.strptime row[:birthday], '%m/%d/%Y'
    contact.active = row[:is_active]

    contact.save!

    tags = row[:tags].split('|').join(', ')
    the_organization.tag(contact, with: tags, on: :tags)
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique
    if (@retry_count += 1) <= 2
      retry
    else
      raise
    end
  end
end
