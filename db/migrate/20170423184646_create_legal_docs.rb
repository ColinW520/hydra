class CreateLegalDocs < ActiveRecord::Migration[5.0]
  def change
    create_table :legal_docs do |t|
      t.string :type
      t.text :content
      t.boolean :is_default

      t.timestamps
    end
  end
end
