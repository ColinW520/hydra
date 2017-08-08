class CreateMediaLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :media_links do |t|
      t.references :message, foreign_key: true
      t.string :link
      t.string :direction

      t.timestamps
    end
  end
end
