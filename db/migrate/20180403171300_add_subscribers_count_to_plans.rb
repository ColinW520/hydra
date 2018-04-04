class AddSubscribersCountToPlans < ActiveRecord::Migration[5.0]
  def change
    add_column :plans, :subscribers_count, :integer, default: 0
  end
end
