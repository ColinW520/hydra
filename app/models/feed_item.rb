class FeedItem < ApplicationRecord
  belongs_to :organization
  belongs_to :user
  belongs_to :parent, polymorphic: true

  scope :interactions, -> { where(parent_type: ['Message', 'MessageRequest', 'CallLog']) }
end
