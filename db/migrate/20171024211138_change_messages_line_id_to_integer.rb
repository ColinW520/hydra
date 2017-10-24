class ChangeMessagesLineIdToInteger < ActiveRecord::Migration[5.0]
  def change
    change_column :messages, :line_id, 'integer USING CAST(line_id AS integer)'
    change_column :messages, :message_request_id, 'integer USING CAST(message_request_id AS integer)'
  end
end
