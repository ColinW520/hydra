class AddNotifiedAtToImports < ActiveRecord::Migration[5.0]
  def change
    add_column :imports, :notified_at, :datetime
  end
end
