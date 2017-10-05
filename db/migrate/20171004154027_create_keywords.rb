class CreateKeywords < ActiveRecord::Migration[5.0]
  def change
    create_table :keywords do |t|
      t.references :organization, foreign_key: true
      t.references :line, foreign_key: true
      t.string :text
      t.string :response
      t.boolean :is_active
      t.integer :sent_count

      t.timestamps
    end
  end
end
