class AddValueToSubscriptions < ActiveRecord::Migration[5.0]
  def change
    add_column :subscriptions, :value_in_cents, :integer, default: 0
  end
end
