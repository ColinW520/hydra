class AddCanAddIntegrationPartnersToPlans < ActiveRecord::Migration[5.0]
  def change
    add_column :plans, :can_add_integration_partners, :boolean, default: false, after: :can_upload_contacts
  end
end
