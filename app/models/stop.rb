class Stop < ApplicationRecord
  belongs_to :contact
  belongs_to :line
  belongs_to :message

  scope :active, -> { where(rescinded_at: nil) }
end
