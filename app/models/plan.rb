class Plan < ApplicationRecord
  validates :stripe_id, uniqueness: true

  scope :not_removed, -> { where(removed_at: nil, removed_by: nil) }

  def soft_delete(user_id)
    self.removed_by = user_id
    self.removed_at = Time.now
    self.is_available = false
    self.save!
  end

  def stripe_instance
    Stripe::Plan.retrieve self.stripe_id
  end
end
