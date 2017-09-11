class Summarizers::WeeklySummarizingWorker
  include Sidekiq::Worker
  sidekiq_options queue: :mailers

  def perform
  end
end
