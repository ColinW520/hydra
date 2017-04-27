class Twilio::Messages::SendingWorker < Twilio::BaseWorker
  include Sidekiq::Worker

  def perform()

  end
end
