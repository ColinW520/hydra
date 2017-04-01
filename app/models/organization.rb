class Organization < ApplicationRecord
  # tools
  extend FriendlyId
  friendly_id :name, use: :slugged

  # relationships
  has_many :users
  has_many :employees

  # hooks
  after_create :update_primary_user
  def update_primary_user
    # this results in 1 query.
    User.where(id: self.created_by).update_all(organization_id: self.id)
  end

  # helpers

  def soft_delete!(user_id)
    update_attributes(removed_at: Time.current, removed_by: user_id)
  end

  def ready_to_go?
    false
  end
end
