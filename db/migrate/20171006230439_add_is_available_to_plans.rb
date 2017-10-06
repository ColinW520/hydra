class AddIsAvailableToPlans < ActiveRecord::Migration[5.0]
  def change
    add_column :plans, :is_available, :boolean, default: false
  end
end
