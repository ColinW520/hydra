# manage when this is run here: https://scheduler.heroku.com/dashboard
class Summarizers::WeeklySummarizingWorker
  include Sidekiq::Worker
  sidekiq_options queue: :mailers

  def perform
    User.subscribed_to_weekly_summary.pluck(:id).each do |user_id|
      MessagesMailer.weekly_summary(user_id).deliver_later
    end
  end
end
