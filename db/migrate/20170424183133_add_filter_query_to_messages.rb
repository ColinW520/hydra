class AddFilterQueryToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :filter_query, :text
  end
end
