class Line < ApplicationRecord
  belongs_to :organization
  belongs_to :user
  has_many :message_requests
  has_many :messages
  has_many :call_logs
  has_many :feed_items, as: :parent, dependent: :destroy
  has_many :stops

  validates :name, presence: true
  validates :number, presence: true
  validates :user, presence: true
  validates :organization, presence: true

  phony_normalize :number, default_country_code: 'US'
  validates :number, phony_plausible: true

  phony_normalize :voice_forwarding_number, default_country_code: 'US'
  validates :voice_forwarding_number, phony_plausible: true

  scope :active, -> { where(released_at: nil) }

  def last_four
    self.number.last(4)
  end

  def dropdown_name
    "#{self.name} - #{self.number}"
  end

  def twilio_number
    @organization = Organization.find organization_id
    @twilio_client = Twilio::REST::Client.new(@organization.twilio_auth_id, ENV['TWILIO_COLIN_AUTH_TOKEN'])
    return @twilio_client.incoming_phone_numbers.get(self.twilio_id)
  end

  after_create :buy_on_twilio
  def buy_on_twilio
    Twilio::Lines::BuyingWorker.new.perform(self.id) if Rails.env.development?
    Twilio::Lines::BuyingWorker.perform_async(self.id) if Rails.env.production?
  end

  def update_on_twilio
    Twilio::Lines::UpdatingWorker.new.perform(self.id) if Rails.env.development?
    Twilio::Lines::UpdatingWorker.perform_async(self.id) if Rails.env.production?
  end

  def release!(user_id)
    Twilio::Lines::ReleasingWorker.new.perform(self.id, user_id) if Rails.env.development?
    Twilio::Lines::ReleasingWorker.perform_async(self.id, user_id) if Rails.env.production?
  end
end
