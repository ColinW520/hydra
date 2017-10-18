class Subscription < ApplicationRecord
  belongs_to :organization
  belongs_to :plan, primary_key: :stripe_id, foreign_key: :stripe_plan_id
  validates :signer_name, presence: true

  scope :active, -> { where(canceled_at: nil) }

  def is_valid?
    return true unless self.status == 'unpaid' || self.status == 'canceled'
  end

  before_create :create_on_stripe
  def create_on_stripe
    sub_details = {}
    sub_details[:customer] = self.stripe_customer_id
    sub_details[:plan] = self.stripe_plan_id
    sub_details[:coupon] = self.coupon_code if self.coupon_code.present?
    stripe_subscription = Stripe::Subscription.create(sub_details)
    self.stripe_id = stripe_subscription.id
    self.stripe_customer_id = stripe_subscription.customer
  end

  def cancel_on_stripe!(user_id)
    sub = Stripe::Subscription.retrieve(self.stripe_id)
    sub.delete(at_period_end: true)
  end

  def stripe_instance
    Stripe::Subscription.retrieve self.stripe_id
  end
end
