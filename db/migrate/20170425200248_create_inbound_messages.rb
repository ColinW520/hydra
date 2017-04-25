class CreateInboundMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :inbound_messages do |t|
      t.references :organization, foreign_key: true
      t.references :line, foreign_key: true
      t.string :to
      t.string :from
      t.text :body
      t.string :twilio_message_sid
      t.integer :inbound_message_media_count

      t.timestamps
    end
  end
end
