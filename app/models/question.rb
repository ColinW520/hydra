class Question < ApplicationRecord
  include RankedModel
  ranks :display_order
end
