class Twilio::Messages::SendingWorker < Twilio::BaseWorker
  sidekiq_options retry: false

  def perform(message_request_id, contact_id)
    @message_request = MessageRequest.find message_request_id
    @contact = Contact.find contact_id

    # we've somehow already processed a request with this message request id
    return if @contact.messages.where(message_request_id: message_request_id).present?

    return unless @contact.is_active?

    @line = Line.find @message_request.line_id

    prepare_objects(@line.organization_id)

    # prep it
    recipient_hash = {
      from: @line.number,
      body: @message_request.body,
      to: @contact.mobile_phone,
      status_callback: "https://www.textmy.team/twilio/callbacks/status"
    }

    recipient_hash[:media_url] = @message_request.media_item.url if @message_request.media_item.present?

    # send it
    return if Rails.env.development?
    @message = @twilio_client.messages.create(recipient_hash)

    # store it if it has an ID
    Twilio::Messages::StoringWorker.perform_async(@message.sid, @organization.id, @line.id, @contact.id, @message_request.id) if @message.sid.present?
  # rescue Twilio::REST::RequestError => error
  #   if error.message == 'The message From/To pair violates a blacklist rule.'
  #
  #   end
  end
end
