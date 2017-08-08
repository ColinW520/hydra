class MediaItem < ApplicationRecord
  belongs_to :message_request
  delegate :created_by, to: :message_request
end
