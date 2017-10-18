class Invoice < ApplicationRecord
  extend FriendlyId
  friendly_id :number, use: :slugged

  belongs_to :organization, primary_key: :stripe_customer_id, foreign_key: :customer_id
  belongs_to :subscription, primary_key: :stripe_id, foreign_key: :subscription_id

  scope :unpaid, -> { where(paid: false) }

  def stripe_instance
    Stripe::Invoice.retrieve(self.stripe_id)
  end
end
