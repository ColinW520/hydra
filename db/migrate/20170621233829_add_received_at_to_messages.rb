class AddReceivedAtToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :received_at, :datetime
  end
end
