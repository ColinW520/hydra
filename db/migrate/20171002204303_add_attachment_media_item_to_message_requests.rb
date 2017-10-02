class AddAttachmentMediaItemToMessageRequests < ActiveRecord::Migration
  def self.up
    change_table :message_requests do |t|
      t.attachment :media_item
    end
  end

  def self.down
    remove_attachment :message_requests, :media_item
  end
end
