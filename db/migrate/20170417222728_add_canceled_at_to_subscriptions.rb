class AddCanceledAtToSubscriptions < ActiveRecord::Migration[5.0]
  def change
    add_column :subscriptions, :canceled_at, :datetime, after: :canceled_by
  end
end
