class RenamecontactsToContacts < ActiveRecord::Migration[5.0]
  def change
    rename_table :contacts, :contacts
  end
end
