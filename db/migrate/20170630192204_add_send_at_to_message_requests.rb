class AddSendAtToMessageRequests < ActiveRecord::Migration[5.0]
  def change
    add_column :message_requests, :send_at, :datetime
  end
end
