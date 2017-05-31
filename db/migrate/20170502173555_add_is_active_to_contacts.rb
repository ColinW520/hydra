class AddIsActiveToContacts < ActiveRecord::Migration[5.0]
  def change
    add_column :contacts, :is_active, :boolean, default: true
  end
end
