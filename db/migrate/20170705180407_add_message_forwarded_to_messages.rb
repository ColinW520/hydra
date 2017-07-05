class AddMessageForwardedToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :forwarded_to, :string
  end
end
