class Twilio::Messages::QueuingWorker < Twilio::BaseWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable
  sidekiq_options queue: :twilio

  def perform(message_id)
    @message = Message.find message_id
    @message.touch(:processed_at)
    @recipients = contact.filter_by(JSON.parse(@message.filter_query).pluck(:id))
    if Rails.env.production?
      @recipients.each do { |recipient| Twilio::Messages::SendingWorker.perform_async(@message.id, recipient)}
    else
      @recipients.each do { |recipient| Twilio::Messages::SendingWorker.perform_async(@message.id, recipient)}
    end
  end
end
