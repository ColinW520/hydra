class AddPhoneIsValidForSmsTocontacts < ActiveRecord::Migration[5.0]
  def change
    add_column :contacts, :phone_is_valid_for_sms, :boolean
  end
end
