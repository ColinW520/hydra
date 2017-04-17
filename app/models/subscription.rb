class Subscription < ApplicationRecord
  belongs_to :organization

  validates :stripe_id, presence: true
  validates :stripe_customer_id, presence: true
  validates :stripe_plan_id, presence: true

  before_validation :create_on_stripe
  def create_on_stripe
    sub_details = {}
    sub_details[:customer] = self.stripe_customer_id
    sub_details[:plan] = Stripe::Plan.list.first.id
    sub_details[:coupon] = self.coupon_code if self.coupon_code.present?
    stripe_subscription = Stripe::Subscription.create(sub_details)
    self.stripe_id = stripe_subscription.id
    self.stripe_plan_id = stripe_subscription.plan.id
    self.stripe_customer_id = stripe_subscription.customer
  end

  def cancel_on_stripe!
    sub = Stripe::Subscription.retrieve(self.stripe_id)
    sub.at_period_end = true
    sub.save
  end
end
