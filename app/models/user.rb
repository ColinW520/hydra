class User < ApplicationRecord
  default_scope -> { where(deleted_at: nil) }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         invite_key: { email: Devise.email_regexp, first_name: :present?.to_proc, last_name: :present?.to_proc, mobile_phone: :present?.to_proc, organization_id: :present?.to_proc}

  belongs_to :organization

  def setup?
    self.organization.present?
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
end
