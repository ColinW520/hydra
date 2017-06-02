class Contact < ApplicationRecord
  acts_as_taggable

  belongs_to :organization
  has_many :messages

  validates :organization,
            presence: true

  validates :first_name,
            presence: true

  validates :mobile_phone,
            presence: true,
            numericality: { only_integer: true },
            uniqueness: { scope: [:organization_id] }


  scope :name_like, ->(term) { where('first_name ILIKE ? OR last_name ILIKE ?', "%#{term}%", "%#{term}%") }
  scope :title_like, ->(term) { where('title ILIKE ?', "%#{term}%") }

  def tag_list_for_form
    self.tags.pluck(:name).join(', ')
  end

  def self.filter_by(params)
    contacts_scope = self.includes(:organization)
    contacts_scope = contacts_scope.where(id: params[:id]) if params[:id].present?
    contacts_scope = contacts_scope.name_like(params[:name]) if params[:name].present?
    contacts_scope = contacts_scope.title_like(params[:title]) if params[:title].present?
    contacts_scope = contacts_scope.tagged_with(params[:tags]) if params[:tags].present?

    return contacts_scope
  end

  def self.to_csv
    attributes = self.column_names
    attributes << 'tags'

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |contact|
        csv << attributes.map { |attr| attr == 'tags' ? contact.tags.pluck(:name).split(',').join('|') : contact.send(attr) }
      end
    end
  end
end
