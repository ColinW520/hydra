class Twilio::MessagesController < Twilio::BaseController
  def create
    Twilio::Messages::ReceivingWorker.new.perform(params) if Rails.env.development?
    Twilio::Messages::ReceivingWorker.perform_async(params) if Rails.env.production?
  end
end
