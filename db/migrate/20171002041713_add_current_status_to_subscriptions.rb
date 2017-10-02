class AddCurrentStatusToSubscriptions < ActiveRecord::Migration[5.0]
  def change
    add_column :subscriptions, :current_status, :string
  end
end
