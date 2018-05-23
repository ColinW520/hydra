class IntegrationPartner < ApplicationRecord
  belongs_to :organization

  SUPPORTED_PROVIDERS = [ "Valence", "MailChimp (Not Yet)" ]

end
