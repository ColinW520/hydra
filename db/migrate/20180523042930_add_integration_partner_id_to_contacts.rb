class AddIntegrationPartnerIdToContacts < ActiveRecord::Migration[5.0]
  def change
    add_reference :contacts, :integration_partner, foreign_key: true, after: :organization_id
  end
end
