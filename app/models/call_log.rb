class CallLog < ApplicationRecord
  belongs_to :contact
  belongs_to :organization
  belongs_to :line

  validates :contact_id, presence: true
  validates :organization_id, presence: true
  validates :line_id, presence: true

  validates :call_sid, presence: true, uniqueness: true
end
