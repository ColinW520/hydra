class Stripe::SubscriptionSyncWorker
  include Sidekiq::Worker

  def perform
    Subscription.find_each do |local_subscription|
      @stripe_subscription = local_subscription.stripe_instance
      local_subscription.canceled_at = @stripe_subscription.canceled_at if @stripe_subscription.canceled_at.present?
      local_subscription.current_status = @stripe_subscription.status

      # now calculate the value of this Subscription
      plan_value = @stripe_subscription.plan.amount

      coupon = @stripe_subscription.discount.try(:coupon)
      if coupon.present?
        local_subscription.value_in_cents = plan_value - coupon.amount_off if coupon.amount_off.present?
        local_subscription.value_in_cents = plan_value - (( coupon.percent_off / 100 ) * plan_value) if coupon.percent_off.present?
      else
        puts "no coupon  \n\n"
        local_subscription.value_in_cents = plan_value
      end
      # end value calc

      local_subscription.save!
    end

    puts "Synchronized #{Subscription.count} subscriptions. \n\n"
  end
end
