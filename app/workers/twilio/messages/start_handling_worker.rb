class Twilio::Messages::StartHandlingWorker < Twilio::BaseWorker
  def perform(message_id)
    @message = Message.find message_id
    @stop = Stop.where(line_id: @message.line_id, contact_id: @message.contact_id).first
    @stop.update_attributes(rescinded_at: @message.created_at)
  end
end
