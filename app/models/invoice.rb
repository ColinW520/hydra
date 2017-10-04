class Invoice < ApplicationRecord

  def stripe_instance
    Stripe::Invoice.retrieve(self.stripe_id)
  end
end
