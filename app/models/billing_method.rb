class BillingMethod < ApplicationRecord
  belongs_to :organization

  scope :valid, -> { where.not(id: nil) }
end
