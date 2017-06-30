class Twilio::MessagesController < Twilio::BaseController
  def create
    Rails.logger.info params

    Twilio::Messages::ReceivingWorker.new.perform(params) if Rails.env.development?
    Twilio::Messages::ReceivingWorker.perform_async(params) if Rails.env.production?
  end
end

# https://463b06db.ngrok.io/twilio/messages
