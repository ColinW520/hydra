class AddStripeCustomerIdtoOrganizations < ActiveRecord::Migration[5.0]
  def change
    add_column :organizations, :stripe_customer_id, :string
  end
end
