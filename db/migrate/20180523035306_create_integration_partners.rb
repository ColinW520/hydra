class CreateIntegrationPartners < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_partners do |t|
      t.references :organization, foreign_key: true
      t.boolean :is_active, default: true
      t.string :name
      t.string :auth_key
      t.string :auth_username
      t.string :auth_password
      t.string :subdomain_scope
      t.boolean :sync_users, default: true
      t.boolean :sync_contacts, default: true
      t.datetime :last_synchronized_at

      t.timestamps
    end
  end
end
