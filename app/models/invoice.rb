class Invoice < ApplicationRecord
  belongs_to :organization, primary_key: :stripe_customer_id, foreign_key: :customer_id
  belongs_to :subscription, primary_key: :stripe_id, foreign_key: :subscription_id

  def stripe_instance
    Stripe::Invoice.retrieve(self.stripe_id)
  end
end
