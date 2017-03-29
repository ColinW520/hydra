class AddRemovalFeildsToOrganizations < ActiveRecord::Migration[5.0]
  def change
    add_column :organizations, :removed_at, :datetime
    add_column :organizations, :removed_by, :integer
  end
end
