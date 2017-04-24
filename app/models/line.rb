class Line < ApplicationRecord
  belongs_to :organization
  belongs_to :user
end
