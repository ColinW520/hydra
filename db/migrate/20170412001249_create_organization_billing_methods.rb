class CreateOrganizationBillingMethods < ActiveRecord::Migration[5.0]
  def change
    create_table :billing_methods do |t|
      t.references :organization, foreign_key: true
      t.string :nickname
      t.string :stripe_token_id
      t.integer :created_by
      t.datetime :removed_at
      t.datetime :last_succeeded_at
      t.datetime :last_failed_at
      t.timestamps
    end
  end
end
