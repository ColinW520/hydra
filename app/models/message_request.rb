class MessageRequest < ApplicationRecord
  has_many :feed_items, as: :parent, dependent: :destroy
  belongs_to :user
  belongs_to :organization
  belongs_to :line
  serialize :filter_query, JSON
  has_many :messages

  has_attached_file :media_item,
    dependent: :destroy
  validates_attachment_content_type :media_item, content_type: /\Aimage\/.*\Z/
  validates_attachment :media_item, content_type: { content_type: ['image/jpeg', 'image/gif', 'image/png'] }

  validates :body, presence: true

  scope :sent, -> { where.not(processed_at: nil) }

  def expected_recipients
    Contact.filter_by JSON.parse self.filter_query
  end

  def actual_recipients
    Contact.where(id: self.messages.pluck(:contact_id))
  end

  after_create :queue_message
  def queue_message
    Twilio::Messages::QueuingWorker.perform_in(5.seconds, self.id)
  end

  def self.to_csv
    attributes = self.column_names

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |request|
        csv << attributes.map { |attr| contact.send(attr) }
      end
    end
  end
end
