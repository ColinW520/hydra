class IntegrationPartner < ApplicationRecord
  belongs_to :organization

  SUPPORTED_PROVIDERS = [ 'Valence', 'MailChimp (Not Yet)' ]

  scope :valence, -> { where(name: 'Valence') }
  scope :active, -> { where(is_active: true) }
end
