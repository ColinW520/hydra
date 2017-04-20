class AddAttachmentDatafileToImports < ActiveRecord::Migration
  def self.up
    change_table :imports do |t|
      t.attachment :datafile
    end
  end

  def self.down
    remove_attachment :imports, :datafile
  end
end
