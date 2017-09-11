class Twilio::Messages::AutoResponseSendingWorker < Twilio::BaseWorker
  sidekiq_options retry: false

  def perform(line_id, contact_id)
    @contact = Contact.find contact_id
    @line = Line.find line_id

    prepare_objects(@line.organization_id)

    # prep it
    recipient_hash = { from: @line.number, body: @line.sms_auto_response_text }
    recipient_hash[:to] = @contact.mobile_phone
    recipient_hash[:status_callback] = "https://www.textmy.team/twilio/callbacks/status" if Rails.env.production?

    # send it
    @message = @twilio_client.messages.create(recipient_hash)

    # store it
    Twilio::Messages::StoringWorker.perform_async(@message.sid, @line.organization_id, @line.id, @contact.id)
  end
end
