class Twilio::Messages::SendingWorker < Twilio::BaseWorker
  sidekiq_options retry: false

  def perform(message_request_id, contact_id)
    @message_request = MessageRequest.find message_request_id
    @contact = Contact.find contact_id

    prepare_objects(@message_request.organization_id)

    @line = Line.find @message_request.line_id
    @twilio_client = Twilio::REST::Client.new(@organization.twilio_auth_id, ENV['TWILIO_COLIN_AUTH_TOKEN'])

    # prep it
    recipient_hash = { from: @line.number, body: @message_request.body }
    recipient_hash[:to] = @contact.mobile_phone
    recipient_hash[:status_callback] = "https://www.textmy.team/twilio/callbacks/status" if Rails.env.production?

    # send it
    @message = @twilio_client.messages.create(recipient_hash)

    # check it
    @message.refresh

    # store it
    @local_message = Message.new
    @local_message.sms_sid = @message.sid
    @local_message.twilio_sid = @message.sid
    @local_message.message_request_id = @message_request.id
    @local_message.line_id = @line.id
    @local_message.status = @message.status
    @local_message.direction = 'outbound'
    @local_message.sent_at = Time.now
    @local_message.to = @message.to
    @local_message.from = @message.from
    @local_message.body = @message.body
    @local_message.error_message = @message.error_message
    @local_message.price_in_cents = 0.0075
    @local_message.account_sid = @message.account_sid
    @local_message.organization_id = @organization.id
    @local_message.contact_id = @contact.id
    @local_message.save!
    @contact.touch(:last_messaged_at)
  end
end
