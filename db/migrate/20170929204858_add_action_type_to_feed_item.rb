class AddActionTypeToFeedItem < ActiveRecord::Migration[5.0]
  def change
    add_column :feed_items, :action_type, :string
  end
end
