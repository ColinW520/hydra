class Twilio::Messages::QueuingWorker < Twilio::BaseWorker
  sidekiq_options retry: false

  def perform(message_request_id)
    @message_request = MessageRequest.find(message_request_id)
    return if @message_request.processed_at.present?

    @recipients = Contact.filter_by JSON.parse @message_request.filter_query
    @recipients = @recipients.where(organization_id: @message_request.organization_id)


    return unless @recipients.present?

    @recipients.pluck(:id).each { |recipient_id| Twilio::Messages::SendingWorker.perform_async(@message_request.id, recipient_id) }
    @message_request.touch(:processed_at)
  end
end
