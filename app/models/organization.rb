class Organization < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  # relationships
  has_many :users
  has_many :employees
  has_many :billing_methods
  has_one :primary_billing_method, ->(organization) { where(stripe_token_id: organization.stripe_token_id) }, class_name: 'BillingMethod'
  has_one :subscription


  def stripe_customer
    return nil unless self.stripe_customer_id
    Stripe::Customer.retrieve self.stripe_customer_id
  end

  def default_card
    return nil unless self.stripe_customer_id
    customer = Stripe::Customer.retrieve self.stripe_customer_id
    card = customer.sources.retrieve(customer.default_source)
    return card
  end

  # hooks
  after_create :update_primary_user
  def update_primary_user
    # this results in 1 query.
    User.where(id: self.created_by).update_all(organization_id: self.id)
  end

  before_create :create_stripe_customer
  def create_stripe_customer
    customer_details = {}
    customer_details[:description] = self.name
    customer_details[:email] = self.email_domain
    customer_details[:metadata] = {
      created_by_id: self.created_by,
      name: self.name
    }
    customer = Stripe::Customer.create customer_details
    self.stripe_customer_id = customer.id
  end

  # helpers

  def soft_delete!(user_id)
    update_attributes(removed_at: Time.current, removed_by: user_id)
  end
end
