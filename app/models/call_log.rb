class CallLog < ApplicationRecord
  belongs_to :contact
  belongs_to :organization
  belongs_to :line

  validates :contact_id, presence: true
  validates :organization_id, presence: true
  validates :line_id, presence: true

  validates :call_sid, presence: true, uniqueness: true

  phony_normalize :called, default_country_code: 'US'
  phony_normalize :forwarded_to, default_country_code: 'US'
  phony_normalize :caller, default_country_code: 'US'
  phony_normalize :to, default_country_code: 'US'
  phony_normalize :from, default_country_code: 'US'

  validates :called, phony_plausible: true
  validates :caller, phony_plausible: true
  validates :to, phony_plausible: true
  validates :from, phony_plausible: true
  validates :forwarded_to, phony_plausible: true
end
