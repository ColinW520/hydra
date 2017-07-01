class MessageRequest < ApplicationRecord
  belongs_to :user
  belongs_to :organization
  belongs_to :line
  serialize :filter_query, JSON

  validates :body, presence: true, length: { minimum: 1, maximum: 140 }

  after_create :queue_message
  def queue_message
      Twilio::Messages::QueuingWorker.perform_async(self.id) if Rails.env.production?
      Twilio::Messages::QueuingWorker.new.perform(self.id) if Rails.env.development?
    end
  end
end
