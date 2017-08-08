class MediaItem < ApplicationRecord
  belongs_to :message_request
  delegate :created_by, to: :message_request

  has_attached_file :image,
                    hash_secret: 'a92342be23ad9827634654a5617646',
                    path: 'message_request_media_items/:organization_id/:created_year/:created_month/image.:extension'

end
