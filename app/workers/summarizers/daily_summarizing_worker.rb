# manage when this is run here: https://scheduler.heroku.com/dashboard
class Summarizers::DailySummarizingWorker
  include Sidekiq::Worker
  sidekiq_options queue: :mailers

  def perform
    User.subscribed_to_daily_summary.pluck(:id).each do |user_id|
      MessagesMailer.daily_summary(user_id).deliver_later
    end
  end
end
