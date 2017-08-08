class AddAttachmentImageToMediaItems < ActiveRecord::Migration
  def self.up
    change_table :media_items do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :media_items, :image
  end
end
