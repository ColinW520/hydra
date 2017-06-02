class AddContactToMessages < ActiveRecord::Migration[5.0]
  def change
    add_reference :messages, :contact, foreign_key: true
  end
end
