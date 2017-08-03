class AddInternalIdentifierToContacts < ActiveRecord::Migration[5.0]
  def change
    add_column :contacts, :internal_identifier, :string

    add_index :contacts, [:internal_identifier]
  end
end
