class Plan < ApplicationRecord
  validates :stripe_id, uniqueness: true

  scope :available, -> { where(is_available: true) }
end
