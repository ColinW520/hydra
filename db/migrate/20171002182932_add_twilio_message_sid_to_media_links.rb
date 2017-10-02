class AddTwilioMessageSidToMediaLinks < ActiveRecord::Migration[5.0]
  def change
    add_column :media_links, :twilio_message_sid, :string, after: :id
    add_column :media_links, :twilio_file_type, :string, after: :link
  end
end
