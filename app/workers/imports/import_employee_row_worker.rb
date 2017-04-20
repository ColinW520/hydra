class Imports::ImportEmployeeRowWorker
  include Sidekiq::Worker

  def perform(row, import_id)
    the_import = Import.find import_id

    new_employee = Employee.new
    new_employee.organization_id = the_import.organization_id
    new_employee.first_name = row[:first_name]
    new_employee.last_name = row[:last_name]
    new_employee.email = row[:email]
    new_employee.mobile_phone = row[:phone].gsub(/\D/, '')
    new_employee.save!
  end
end
