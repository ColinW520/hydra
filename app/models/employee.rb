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
    where('first_name ILIKE ? OR last_name ILIKE ?', "%#{term}%", "%#{term}%")
  }

  scope :title_like, ->(term) {
    where('title ILIKE ?', "%#{term}%")
  }

  def self.to_csv
    attributes = self.column_names
    attributes << 'tags'

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |employee|
        csv << attributes.map { |attr| attr == 'tags' ? employee.tags.pluck(:name).split(',').join('|') : employee.send(attr) }
      end
    end
  end
end
