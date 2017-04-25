class MessageRecipient < ApplicationRecord
  belongs_to :message
  belongs_to :employee
end
