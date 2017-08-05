class Twilio::Messages::SendingWorker < Twilio::BaseWorker
  sidekiq_options retry: false

  def perform(message_request_id, contact_id)
    @message_request = MessageRequest.find message_request_id
    @contact = Contact.find contact_id

    # we've somehow already processed a request with this message request id
    return if contact.messages.where(messsage_request_id: message_request_id).present?

    @line = Line.find @message_request.line_id

    prepare_objects(@line.organization_id)

    # prep it
    recipient_hash = {
      from: @line.number,
      body: @message_request.body,
      to: @contact.mobile_phone,
      status_callback: "https://www.textmy.team/twilio/callbacks/status"
    }

    # send it
    @message = @twilio_client.messages.create(recipient_hash)

    # store it
    Twilio::Messages::StoringWorker.perform_asyncperform(@message.twilio_sid, @organization.id, @line.id, @contact.id)
  end
end
