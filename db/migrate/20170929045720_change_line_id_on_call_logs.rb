class ChangeLineIdOnCallLogs < ActiveRecord::Migration[5.0]
  def change
    change_column :call_logs, :line_id, 'integer USING CAST(line_id AS integer)'
  end
end
