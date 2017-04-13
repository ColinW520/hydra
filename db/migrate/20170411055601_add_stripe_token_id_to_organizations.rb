class AddStripeTokenIdToOrganizations < ActiveRecord::Migration[5.0]
  def change
    add_column :organizations, :stripe_token_id, :string
  end
end
