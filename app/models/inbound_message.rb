class InboundMessage < ApplicationRecord
  belongs_to :organization
  belongs_to :line
end
