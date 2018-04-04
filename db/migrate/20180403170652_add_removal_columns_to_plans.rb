class AddRemovalColumnsToPlans < ActiveRecord::Migration[5.0]
  def change
    add_column :plans, :removed_by, :integer
    add_column :plans, :removed_at, :datetime
  end
end
