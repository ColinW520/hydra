class AddEndsAtToSubscriptions < ActiveRecord::Migration[5.0]
  def change
    add_column :subscriptions, :ends_at, :datetime
  end
end
