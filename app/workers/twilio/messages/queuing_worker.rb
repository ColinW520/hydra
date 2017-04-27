# this is responsible for taking a Hydra message, and queuing up a message sending worker for each message recipient at a rate of 5 per second
class Twilio::Messages::QueuingWorker < Twilio::BaseWorker
  include Sidekiq::Worker

  def perform()

  end
end
