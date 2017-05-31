class AddLineToMessageRequests < ActiveRecord::Migration[5.0]
  def change
    add_reference :message_requests, :line, foreign_key: true, after: :organization_id
    add_column :message_requests, :filter_query, :text
    add_column :message_requests, :filter_query, :text
  end
end
