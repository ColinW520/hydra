class Message < ApplicationRecord
  belongs_to :user
  belongs_to :organization
  belongs_to :line
  has_many :message_recipients
  serialize :filter_query, JSON

  validates :body, presence: true, length: { minimum: 2, maximum: 140 }

  after_create :queue_message
  def queue_message
    if Rails.env.production?
      Twilio::Messages::QueueingWorker.perform_async(self.id)
    else
      Twilio::Messages::QueueingWorker.new.perform(self.id)
    end
  end
end
