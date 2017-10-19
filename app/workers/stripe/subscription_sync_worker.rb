class Stripe::SubscriptionSyncWorker
  include Sidekiq::Worker

  def perform
    Subscription.find_each do |local_subscription|
      @stripe_subscription = local_subscription.stripe_instance
      local_subscription.canceled_at = @stripe_subscription.canceled_at if @stripe_subscription.canceled_at.present?
      local_subscription.current_status = @stripe_subscription.status

      # now calculate the value of this Subscription
      plan_value = @stripe_subscription.plan.amount
      calc_value = nil
      coupon = @stripe_subscription.discount.try(:coupon)
      if coupon.present?
        calc_value = plan_value - coupon.amount_off if coupon.amount_off.present?
        calc_value = plan_value - (( coupon.percent_off / 100 ) * plan_value) if coupon.percent_off.present?
      end
      local_subscription.value_in_cents = calc_value.nil? ? calc_value : plan_value
      # end value calc


      local_subscription.save!
    end
  end
end
