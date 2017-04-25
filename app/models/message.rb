class Message < ApplicationRecord
  belongs_to :user
  belongs_to :organization
  belongs_to :line
  has_many :message_recipients
  serialize :filter_query


  validates :body, presence: true, length: { minimum: 2, maximum: 140 }
end
