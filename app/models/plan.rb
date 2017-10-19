class Plan < ApplicationRecord
  validates :stripe_id, uniqueness: true

  scope :available, -> { where(is_available: true) }

  def stripe_instance
    Stripe::Plan.retrieve self.stripe_id
  end
end
