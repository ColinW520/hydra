class CreateMediaItems < ActiveRecord::Migration[5.0]
  def change
    create_table :media_items do |t|
      t.references :message_request, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
