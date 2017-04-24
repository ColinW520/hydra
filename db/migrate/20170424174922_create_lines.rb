class CreateLines < ActiveRecord::Migration[5.0]
  def change
    create_table :lines do |t|
      t.references :organization, foreign_key: true
      t.references :user, foreign_key: true
      t.string :twilio_id
      t.string :number
      t.string :name
      t.boolean :forwarding_enabled
      t.string :forwarding_number

      t.timestamps
    end
  end
end
