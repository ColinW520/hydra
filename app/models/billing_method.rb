class BillingMethod < ApplicationRecord
  default_scope -> { where(removed_at: nil) }
  belongs_to :organization

  scope :valid, -> { where.not(id: nil) }

  def stripe_card
    token = Stripe::Card.retrieve self.stripe_token_id
    return token.card
  end

  after_create :update_organization
  def update_organization
    customer = Stripe::Customer.retrieve self.organization.stripe_customer_id
    customer.source = self.stripe_token_id
    customer.save
    self.organization.stripe_token_id = self.stripe_token_id
    self.organization.save!
  end

  def soft_delete!(user_id)
    self.removed_at = Time.now
    self.removed_by = user_id
    self.save!
  end
end
