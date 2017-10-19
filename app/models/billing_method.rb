class BillingMethod < ApplicationRecord
  default_scope -> { where(removed_at: nil) }
  belongs_to :organization

  def stripe_instance
    self.organization.stripe_instance.sources.retrieve(self.stripe_token_id)
  end

  before_create :update_stripe_customer
  def update_stripe_customer
    customer = Stripe::Customer.retrieve self.organization.stripe_customer_id
    customer.source = self.stripe_token_id
    customer.save
  end

  after_create :update_organization
  def update_organization
    self.organization.stripe_token_id = self.stripe_token_id
    self.organization.save!
  end

  def soft_delete!(user_id)
    self.removed_at = Time.now
    self.removed_by = user_id
    self.save!
  end
end
