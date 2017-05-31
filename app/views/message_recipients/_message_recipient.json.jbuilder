json.extract! message_recipient, :id, :message_id, :contact_id, :to_number, :from_number, :twilio_id, :sent_at, :error_message, :created_at, :updated_at
json.url message_recipient_url(message_recipient, format: :json)
