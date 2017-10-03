class Organization < ApplicationRecord
  acts_as_tagger
  extend FriendlyId
  friendly_id :name, use: :slugged

  phony_normalize :phone, default_country_code: 'US'
  validates :phone, phony_plausible: true

  # relationships
  has_many :users, dependent: :destroy
  has_many :feed_items
  has_many :ahoy_events, through: :user
  has_many :contacts, dependent: :destroy
  has_many :billing_methods, dependent: :destroy
  has_many :imports, dependent: :destroy
  has_one :primary_billing_method, ->(organization) { where(stripe_token_id: organization.stripe_token_id) }, class_name: 'BillingMethod'
  has_one :subscription
  has_one :plan, through: :subscription
  has_many :messages, dependent: :destroy
  has_many :message_requests, dependent: :destroy
  has_many :lines
  has_many :call_logs, dependent: :destroy

  validates :name, presence: true

  def valid_setup?
    return false unless self.twilio_auth_id
    return false unless self.subscription.present?
    return false if self.subscription.current_status == 'canceled' || self.subscription.current_status == 'unpaid'
    return true
  end

  def twilio_account
    return Twilio::REST::Client.new self.twilio_auth_id, ENV['TWILIO_COLIN_AUTH_TOKEN']
  end

  def stripe_customer
    return nil unless self.stripe_customer_id
    Stripe::Customer.retrieve self.stripe_customer_id
  end

  def default_card
    return nil unless self.stripe_customer_id
    customer = Stripe::Customer.retrieve self.stripe_customer_id
    card = customer.default_source.present? ? customer.sources.retrieve(customer.default_source) : nil
    return card
  end

  def stripe_subscription
    return nil unless self.subscription.present?
    Stripe::Subscription.retrieve self.subscription.stripe_id
  end

  def twilio_client
    Twilio::REST::Client.new(self.twilio_auth_id, ENV['TWILIO_COLIN_AUTH_TOKEN'])
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
