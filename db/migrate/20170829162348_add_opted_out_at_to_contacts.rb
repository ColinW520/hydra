class AddOptedOutAtToContacts < ActiveRecord::Migration[5.0]
  def change
    add_column :contacts, :opted_out_at, :datetime
  end
end
