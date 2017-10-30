# manage when this is run here: https://scheduler.heroku.com/dashboard
class Stripe::PlanSyncWorker
  include Sidekiq::Worker

  def perform
    Stripe::Plan.list.each do |stripe_plan|
      local_plan = Plan.where(stripe_id: stripe_plan.id).first_or_initialize
      local_plan.amount_in_cents = stripe_plan.amount
      local_plan.name = stripe_plan.name
      local_plan.trial_period_days = stripe_plan.trial_period_days
      local_plan.statement_descriptor = stripe_plan.statement_descriptor
      local_plan.is_available = stripe_plan.metadata[:available] == 'true' ? true : false
      local_plan.save!
    end

    puts "Synchronized #{Plan.count} plans. \n\n"
  end
end
