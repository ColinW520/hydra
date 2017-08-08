class Twilio::Messages::StoringWorker < Twilio::BaseWorker

  def perform(twilio_sid, organization_id, line_id, contact_id, message_request_id = nil)
    @organization = Organization.find organization_id
    @line = Line.find line_id
    @contact = Contact.find contact_id
    @twilio_client = @organization.twilio_client

    @message = @twilio_client.messages.get twilio_sid

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
      direction: @message.direction == 'outbound-api' ? 'outbound' : 'inbound',
      sent_at: DateTime.parse(@message.date_sent),
      to: @message.to,
      from: @message.from,
      body: @message.body,
      error_message: @message.error_message,
      price_in_cents: @message.price.to_f.abs.to_s,
      num_media: @message.num_media,
      num_segments: @message.num_segments
    )

    @contact.touch(:last_messaged_at)
  end
end
