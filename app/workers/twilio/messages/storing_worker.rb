class Twilio::Messages::StoringWorker < Twilio::BaseWorker

  def perform(twilio_sid, organization_id, line_id, contact_id, message_request_id = nil)
    @organization = Organization.find organization_id
    @line = Line.find line_id
    @contact = Contact.find contact_id
    @twilio_client = Twilio::REST::Client.new(@organization.twilio_auth_id, ENV['TWILIO_COLIN_AUTH_TOKEN'])

    @message = @twilio_client.account.messages.get(twilio_sid)

    # store it
    @local_message = Message.where(twilio_sid: @message.sid).first_or_create(
      sms_sid: @message.sid,
      twilio_sid: @message.sid,
      account_sid: @message.account_sid,
      line_id: @line.id,
      organization_id: @organization.id,
      contact_id: @contact.id,
      message_request_id: message_request_id,
      status: @message.status,
      direction: @message.direction,
      sent_at: DateTime.parse(@message.date_sent),
      to: @message.to,
      from: @message.from,
      body: @message.body,
      error_message: @message.error_message,
      price_in_cents: @message.price.to_f.abs,
      from_zip: @message.from_zip,
      from_city: @message.from_city,
      from_state: @message.from_state,
      from_country: @message.from_country,
      num_media: @message.num_media,
      num_segments: @message.num_segments,
      received_at: @message.direction == 'inbound' ? Time.now : nil
    )

    @contact.touch(:last_messaged_at)
  end
end
