class User < ApplicationRecord
  default_scope -> { where(deleted_at: nil) }

  phony_normalize :mobile_phone, default_country_code: 'US'
  validates :mobile_phone, phony_plausible: true

  has_many :ahoy_events, dependent: :destroy, class_name: 'Ahoy::Event'
  has_many :feed_items
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         invite_key: { email: Devise.email_regexp, first_name: :present?.to_proc, last_name: :present?.to_proc, mobile_phone: :present?.to_proc, organization_id: :present?.to_proc}

  belongs_to :organization

  scope :forwarding_capable, -> { where(mobile_phone_validated: true) }
  scope :subscribed_to_instant_alerts, -> { where(notify_instantly: true) }
  scope :subscribed_to_daily_summary, -> { where(summarize_daily: true) }
  scope :subscribed_to_weekly_summary, -> { where(summarize_weekly: true) }
  scope :subscribed_to_signup_alerts, -> { where(send_signup_notifications: true) }
  scope :super_admins, -> { where(is_super_user: true) }
  scope :active, -> { where(deleted_at: nil) }


  before_create :validate_mobile_phone
  def validate_mobile_phone
    if self.organization.present?
      @client = Twilio::REST::LookupsClient.new(self.organization.twilio_auth_id, ENV['TWILIO_COLIN_AUTH_TOKEN'])
      number = @client.phone_numbers.get(self.mobile_phone, type: "carrier")
    else
      @client = Twilio::REST::LookupsClient.new(ENV['DEFAULT_AUTH_ID'], ENV['TWILIO_COLIN_AUTH_TOKEN'])
      number = @client.phone_numbers.get(self.mobile_phone, type: "carrier")
    end
    self.mobile_phone_validated = true if number.carrier['type'] == 'mobile'
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def safe_to_cancel?
    !self.admin_role?
  end

  def inviter
    User.find_by_id self.invited_by
  end

  def setup?
    self.organization.present? && self.organization.valid_setup?
  end

  def soft_delete!
    update_attribute(:deleted_at, Time.current)
  end

  def active_for_authentication?
    super && !deleted_at
  end

  def inactive_message
    !deleted_at ? super : :deleted_account
  end

  def forward_to_dropdown_name
    "#{self.first_name} - #{self.mobile_phone}"
  end
end
