class Twilio::Messages::QueuingWorker < Twilio::BaseWorker

  def perform(message_id)
    @message_request = MessageRequest.find message_id
    @message_request.touch(:processed_at)
    @recipients = Contact.filter_by JSON.parse @message_request.filter_query

    return unless @recipients.present?

    if Rails.env.production?
      @recipients.pluck(:id).each { |recipient| Twilio::Messages::SendingWorker.perform_async(@message_request.id, recipient) }
    else
      @recipients.pluck(:id).each { |recipient| Twilio::Messages::SendingWorker.new.perform(@message_request.id, recipient) }
    end
  end
end
