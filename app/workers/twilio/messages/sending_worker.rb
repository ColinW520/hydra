class Twilio::Messages::SendingWorker < Twilio::BaseWorker
  include Sidekiq::Worker
  sidekiq_options queue: :single_file

  def perform(message_id, recipient_id)
    @message = Message.find message_id
    @recipient = contact.find recipient_id

    if Rails.env.production?
      @twilio_client.messages.create(
        from: @message.line.number,
        to: @recipient.mobile_phone
        body: @message.body
      )
    else

    end
  end
end
