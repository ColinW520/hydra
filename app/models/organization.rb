class Organization < ApplicationRecord
  has_many :users
  has_many :employees

  def soft_delete!(user_id)
    update_attributes(removed_at: Time.current, removed_by: user_id)
  end

  def ready_to_go?
    false
  end
end
