class CreateCallLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :call_logs do |t|
      t.string :line_id
      t.string :organization_id
      t.string :contact_id
      t.boolean :forwarded
      t.string :forwarded_to
      t.string :direction
      t.string :account_sid
      t.string :call_sid
      t.string :call_status
      t.string :called
      t.string :called_state
      t.string :called_zip
      t.string :called_city
      t.string :called_country
      t.string :caller_country
      t.string :caller_state
      t.string :caller_zip
      t.string :caller_city
      t.string :caller
      t.string :direction
      t.string :to
      t.string :to_zip
      t.string :to_state
      t.string :to_city
      t.string :to_country
      t.string :from
      t.string :from_country
      t.string :from_city
      t.string :from_zip
      t.string :from_state
      t.string :api_version

      t.timestamps
    end
  end
end
