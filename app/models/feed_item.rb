class FeedItem < ApplicationRecord
  belongs_to :organization
  belongs_to :user
  belongs_to :parent, polymorphic: true
end
