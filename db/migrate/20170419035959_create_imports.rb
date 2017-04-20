class CreateImports < ActiveRecord::Migration[5.0]
  def change
    create_table :imports do |t|
      t.references :organization, foreign_key: true
      t.string :type
      t.string :status
      t.string :message
      t.integer :created_by
      t.datetime :completed_at
      t.boolean :is_enqueued

      t.timestamps
    end
  end
end
