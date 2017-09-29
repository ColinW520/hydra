class MessageRequest < ApplicationRecord
  has_many :feed_items, as: :parent, dependent: :destroy
  belongs_to :user
  belongs_to :organization
  belongs_to :line
  serialize :filter_query, JSON

  has_many :media_items, dependent: :destroy

  validates :body, presence: true

  after_create :queue_message
  def queue_message
    Twilio::Messages::QueuingWorker.perform_async(self.id)
  end
end
