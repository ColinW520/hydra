class AddAutoTagToLines < ActiveRecord::Migration[5.0]
  def change
    add_column :lines, :apply_tags, :boolean, default: false
  end
end
