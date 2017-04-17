class AddRemovedByToBillingMethods < ActiveRecord::Migration[5.0]
  def change
    add_column :billing_methods, :removed_by, :integer
  end
end
