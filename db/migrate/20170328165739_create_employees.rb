class CreateEmployees < ActiveRecord::Migration[5.0]
  def change
    create_table :employees do |t|
      t.references :organization, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :mobile_phone
      t.string :title
      t.string :preferred_language
      t.datetime :birthday
      t.string :address_line
      t.string :address_city
      t.string :address_state
      t.string :address_zip
      t.datetime :started_at
      t.datetime :ended_at
      t.datetime :last_messaged_at

      t.timestamps
    end
  end
end
