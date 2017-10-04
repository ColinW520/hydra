# these tasks are run by Heroku Scheduler: https://scheduler.heroku.com/dashboard
namespace :summaries do
  # runs daily @ 9:00AM, scheduled in UTC
  desc "Send subsribed users their daily summaries."
  task :send_daily => :environment do
    Summarizers::DailySummarizingWorker.perform_async
  end

  # runs daily @ 9:00AM, scheduled in UTC
  desc "Send subsribed users their weekly summaries."
  task :send_weekly => :environment do
    Summarizers::WeeklySummarizingWorker.perform_async
  end
end

namespace :stripe do
  # runs HOURLY
  desc "Updates Plans with their respective Stripe Info"
  task :sync_plans => :environment do
    Stripe::PlanSyncWorker.perform_async
  end

  # runs HOURLY
  desc "Updates Subscriptions with their respective Stripe Info"
  task :sync_subscriptions => :environment do
    Stripe::SubscriptionSyncWorker.perform_async
  end

  # runs HOURLY
  desc "Updates Invoice with their respective Stripe Info"
  task :sync_invoices => :environment do
    Stripe::InvoiceSyncWorker.perform_async
  end
end
