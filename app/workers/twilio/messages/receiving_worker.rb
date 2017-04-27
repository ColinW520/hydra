class Twilio::Messages::ReceivingWorker < Twilio::BaseWorker
  include Sidekiq::Worker

  def perform()

  end
end
