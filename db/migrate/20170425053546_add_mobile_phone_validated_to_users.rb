class AddMobilePhoneValidatedToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :mobile_phone_validated, :boolean
  end
end
