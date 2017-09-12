# these tasks are run by Heroku Scheduler: https://scheduler.heroku.com/dashboard
namespace :summaries do
  # runs daily @ 9:00AM, scheduled in UTC
  desc "Send subsribed users their daily summaries."
  task :send_daily => :environment do
    puts 'sending daily summaries'
    Summarizers::DailySummarizingWorker.perform_async
  end

  # runs daily @ 9:00AM, scheduled in UTC
  desc "Send subsribed users their weekly summaries."
  task :send_weekly => :environment do
    puts 'sending weekly summaries'
    Summarizers::WeeklySummarizingWorker.perform_async
  end
end
