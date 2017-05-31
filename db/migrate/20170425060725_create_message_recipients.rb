class CreateMessageRecipients < ActiveRecord::Migration[5.0]
  def change
    create_table :message_recipients do |t|
      t.references :message, foreign_key: true
      t.references :contact, foreign_key: true
      t.string :to_number
      t.string :from_number
      t.string :twilio_id
      t.datetime :sent_at
      t.string :error_message

      t.timestamps
    end
  end
end
