class AddSendAtToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :send_at, :datetime
  end
end
