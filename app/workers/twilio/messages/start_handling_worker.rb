class Twilio::Messages::StartHandlingWorker < Twilio::BaseWorker
  def perform
    @message = Message.find message_id
    return unless @message.contact.stops.active.present?
    @stop = Stop.where(line_id: @message.line_id, contact_id: @message.contact_id).last
    @stop.update_attributes(rescinded_at: Time.now)
  end
end
