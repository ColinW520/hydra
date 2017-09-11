class Summarizers::DailySummarizingWorker
  include Sidekiq::Worker
  sidekiq_options queue: :mailers

  def perform
  end
end
