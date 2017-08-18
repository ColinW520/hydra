class Contact < ApplicationRecord
  acts_as_taggable

  belongs_to :organization
  has_many :messages

  validates :organization,
            presence: true


  phony_normalize :mobile_phone, default_country_code: 'US'
  validates :mobile_phone,
            presence: true,
            uniqueness: { scope: [:organization_id] },
            phony_plausible: true

  scope :not_removed, -> { where(removed_at: nil) }
  scope :active, -> { where(active: true) }
  scope :name_like, ->(term) { where('first_name ILIKE ? OR last_name ILIKE ?', "%#{term}%", "%#{term}%") }
  scope :title_like, ->(term) { where('title ILIKE ?', "%#{term}%") }

  def remove(user_id)
    self.removed_at = Time.now
    self.removed_by = user_id
    self.save!
  end

  def textable?
    return false if self.removed_at.present? || !self.is_active?
    return true
  end

  def full_name
    if self.first_name.present? || self.last_name.present?
      "#{self.first_name} #{self.last_name}"
    else
      'unknown'
    end
  end

  def tag_list_for_form
    self.tags.pluck(:name).join(', ')
  end

  def self.filter_by(params)
    params = params.to_unsafe_hash
    contacts_scope = self.includes(:organization)
    contacts_scope = contacts_scope.not_removed
    contacts_scope = contacts_scope.where(internal_identifier: params[:internal_identifier]) if params[:internal_identifier].present?
    contacts_scope = contacts_scope.where(organization_id: params[:organization_id]) if params[:organization_id].present?
    contacts_scope = contacts_scope.where(id: params[:id]) if params[:id].present?
    contacts_scope = contacts_scope.name_like(params[:name]) if params[:name].present?
    contacts_scope = contacts_scope.title_like(params[:title]) if params[:title].present?
    contacts_scope = contacts_scope.tagged_with(params[:tags], any: true, wild: true) if params[:tags].present?
    contacts_scope = contacts_scope.where(contacts: { mobile_phone: params[:mobile_phone] }) if params[:mobile_phone].present?
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
