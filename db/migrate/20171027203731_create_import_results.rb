class CreateImportResults < ActiveRecord::Migration[5.0]
  def change
    create_table :import_results do |t|
      t.references :import, foreign_key: true
      t.text :row_data
      t.string :status
      t.string :result
      t.string :message

      t.timestamps
    end
  end
end
