class Line < ApplicationRecord
  belongs_to :organization
  belongs_to :user
  has_many :messages
  has_many :message_recipients, through: :messages

  validates :name, presence: true
  validates :number, presence: true
  validates :user, presence: true
  validates :organization, presence: true

  def dropdown_name
    "#{self.name} - #{self.number}"
  end

  after_create :buy_on_twilio
  def buy_on_twilio
    Twilio::Lines::BuyingWorker.new.perform(self.id) if Rails.env.development?
    Twilio::Lines::BuyingWorker.perform_async(self.id) if Rails.env.production?
  end

  def release!(user_id)
    Twilio::Lines::ReleasingWorker.new.perform(self.id, user_id) if Rails.env.development?
    Twilio::Lines::ReleasingWorker.perform_async(self.id, user_id) if Rails.env.production?
  end
end
