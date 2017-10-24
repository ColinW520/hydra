class CreateStops < ActiveRecord::Migration[5.0]
  def change
    create_table :stops do |t|
      t.references :contact, foreign_key: true
      t.references :line, foreign_key: true
      t.references :message, foreign_key: true
      t.datetime :rescinded_at

      t.timestamps
    end
  end
end
