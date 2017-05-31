class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.string :twilio_sid
      t.string :message_request_id
      t.string :line_id
      t.string :status
      t.string :direction
      t.datetime :sent_at
      t.string :to
      t.string :from
      t.string :body
      t.string :error_message
      t.decimal :price_in_cents, precision: 8, scale: 5
      t.integer :account_sid
      t.string :organization_id

      t.timestamps
    end
  end
end
