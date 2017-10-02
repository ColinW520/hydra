class MediaLink < ApplicationRecord
  belongs_to :message

  validates :twilio_message_sid, presence: true
  validates :link, presence: true, uniqueness: true
end
