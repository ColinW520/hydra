class AddRemovedAtRemovedByToContacts < ActiveRecord::Migration[5.0]
  def change
    add_column :contacts, :removed_at, :datetime
    add_column :contacts, :removed_by, :string
  end
end
