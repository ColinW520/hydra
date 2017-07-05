class AddAlertSettingsToLines < ActiveRecord::Migration[5.0]
  def change
    add_column :lines, :sms_alert, :boolean
    rename_column :lines, :sms_forwarding_number, :sms_alert_number
    add_column :lines, :email_alert, :boolean
    add_column :lines, :email_alert_address, :boolean
  end
end
