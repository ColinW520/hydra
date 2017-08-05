class RemoveUnusedLogicColumnsFromLines < ActiveRecord::Migration[5.0]
  def change
    remove_column :lines, :use_auto_response
    remove_column :lines, :email_alert_address
    remove_column :lines, :email_alert
    remove_column :lines, :sms_alert_number
    remove_column :lines, :sms_alert
    remove_column :lines, :sms_forwarding_enabled
    remove_column :lines, :forwarding_enabled
    rename_column :lines, :forwarding_number, :voice_forwarding_number
  end
end
