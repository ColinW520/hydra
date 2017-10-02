class Plan < ApplicationRecord
  validates :stripe_id, uniqueness: true
end
