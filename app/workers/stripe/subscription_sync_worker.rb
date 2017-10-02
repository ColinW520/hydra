class Stripe::SubscriptionSyncWorker
  include Sidekiq::Worker

  def perform
    Subscription.find_each do |local_subscription|
      stripe_subscription = Stripe::Subscription.retrieve local_subscription.stripe_id
      local_subscription.canceled_at = stripe_subscription.canceled_at if stripe_subscription.canceled_at.present?
      local_subscription.current_status = stripe_subscription.status
      local_subscription.save!
    end
  end
end
