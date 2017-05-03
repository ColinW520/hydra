class Imports::ImportEmployeeRowWorker
  include Sidekiq::Worker

  def perform(row, import_id)
    row = row.with_indifferent_access
    @retry_count ||= 0
    the_import = Import.find import_id
    the_organization = Organization.find the_import.organization_id

    employee = Employee.where(organization_id: the_organization.id, mobile_phone: row[:phone]).first_or_initialize

    employee.organization_id = the_import.organization_id
    employee.first_name = row[:first_name]
    employee.last_name = row[:last_name]
    employee.email = row[:email]
    employee.mobile_phone = row[:phone].gsub(/\D/, '')

    employee.title = row[:title]
    employee.address_city = row[:city]
    employee.address_state = row[:state]
    employee.address_zip = row[:zip]
    employee.started_at = Date.strptime row[:started_at], '%m/%d/%Y'
    employee.birthday = Date.strptime row[:birthday], '%m/%d/%Y'
    employee.active = row[:is_active]

    employee.save!

    tags = row[:tags].split('|').join(', ')
    the_organization.tag(employee, with: tags, on: :tags)
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique
    if (@retry_count += 1) <= 2
      retry
    else
      raise
    end
  end
end
