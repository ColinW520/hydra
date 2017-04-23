class Employee < ApplicationRecord
  acts_as_taggable

  belongs_to :organization

  validates :organization,
            presence: true

  validates :first_name,
            presence: true

  validates :mobile_phone,
            presence: true,
            numericality: { only_integer: true },
            uniqueness: { scope: [:organization_id] }


  scope :name_like, ->(term) {
    where('first_name ILIKE ? OR last_name ILIKE ?', "#{term}", "#{term}")
  }

  scope :title_like, ->(term) {
    where('first_name ILIKE ? OR last_name ILIKE ?', "#{term}", "#{term}")
  }
end
