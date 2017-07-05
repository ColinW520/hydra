class AddSmsForwardingEnabledToLines < ActiveRecord::Migration[5.0]
  def change
    add_column :lines, :sms_forwarding_enabled, :boolean
    add_column :lines, :sms_forwarding_number, :string
  end
end
