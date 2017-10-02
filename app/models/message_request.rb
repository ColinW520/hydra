class MessageRequest < ApplicationRecord
  has_many :feed_items, as: :parent, dependent: :destroy
  belongs_to :user
  belongs_to :organization
  belongs_to :line
  serialize :filter_query, JSON

  has_attached_file :media_item,
    dependent: :destroy
  validates_attachment_content_type :media_item, content_type: /\Aimage\/.*\Z/
  validates_attachment :media_item, content_type: { content_type: ['image/jpeg', 'image/gif', 'image/png'] }

  validates :body, presence: true

  after_create :queue_message
  def queue_message
    Twilio::Messages::QueuingWorker.perform_in(30.seconds, self.id)
  end
end
