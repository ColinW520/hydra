class AddPostCallAttributesToCallLogs < ActiveRecord::Migration[5.0]
  def change
    add_column :call_logs, :price_in_cents, :decimal, precision: 8, scale: 5
    add_column :call_logs, :duration_in_seconds, :integer
    add_column :call_logs, :answered_by, :string
  end
end
