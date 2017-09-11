class AddAlertsSentToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :alerts_sent, :boolean, default: false
  end
end
