class Twilio::Messages::SendingWorker < Twilio::BaseWorker

  def perform(message_id, contact_id)
    @message_request = MessageRequest.find message_id
    @organization = Organization.find @message_request.organization_id
    @line = Line.find @message_request.line_id
    @client = Twilio::REST::Client.new(@organization.twilio_auth_id, ENV['TWILIO_COLIN_AUTH_TOKEN'])
    @contact = Contact.find contact_id

    # prep it
    recipient_hash = { from: @line.number, body: @message_request.body }
    recipient_hash[:to] = Rails.env.production? ? @contact.mobile_phone : "+13162588774"
    recipient_hash[:status_callback] = "https://hydra.aptx.cm/twilio/callbacks/status" if Rails.env.production?

    # send it
    @message = @client.messages.create(recipient_hash)

    # check it
    @message.refresh

    # store it
    @local_message = Message.new
    @local_message.twilio_sid = @message.sid
    @local_message.message_request_id = @message_request.id
    @local_message.line_id = @line.id
    @local_message.status = @message.status
    @local_message.direction = @message.direction
    @local_message.sent_at = DateTime.parse @message.date_sent
    @local_message.to = @message.to
    @local_message.from = @message.from
    @local_message.body = @message.body
    @local_message.error_message = @message.error_message
    @local_message.price_in_cents = @message.price.to_f.abs
    @local_message.account_sid = @message.sid
    @local_message.organization_id = @organization.id
    @local_message.contact_id = @contact.id
    @local_message.save!
  end
end
