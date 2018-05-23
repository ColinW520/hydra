class AddIntegrationPartnerIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :integration_partner, foreign_key: true
  end
end
