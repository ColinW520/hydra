class AddTwilioAuthIdToOrganizations < ActiveRecord::Migration[5.0]
  def change
    add_column :organizations, :twilio_auth_id, :string
  end
end
