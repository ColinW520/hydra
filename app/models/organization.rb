class Organization < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  # relationships
  has_many :users
  has_many :employees
  has_many :billing_methods

  # hooks
  after_create :update_primary_user
  def update_primary_user
    # this results in 1 query.
    User.where(id: self.created_by).update_all(organization_id: self.id)
  end

  after_create :setup_on_stripe
  def setup_on_stripe
    customer_details = {}
    customer_details[:name] = self.name
    customer_details[:email] = self.email_domain
    Stripe::Customer.create customer_details
  end

  after_save :attach_stripe_source_to_stripe_customer, if: :stripe_token_id_changed?
  def attach_stripe_source_to_stripe_customer
    return unless stripe_token_id.present?
    stripe_customer = Stripe::Customer.retrieve self.stripe_customer_id
    stripe_customer.source = self.stripe_token_id
    stripe_customer.save
  end

  # helpers

  def soft_delete!(user_id)
    update_attributes(removed_at: Time.current, removed_by: user_id)
  end

  def ready_to_go?
    organization_billing_methods.valid.present?
  end
end
