class Twilio::Messages::StopHandlingWorker < Twilio::BaseWorker
  def perform(message_id)
    @message = Message.find message_id
    Stop.create(message_id: @message.id,contact_id: @message.contact_id,line_id: @message.line_id)
  end
end
