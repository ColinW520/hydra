class AddUpdatedByToOrganizations < ActiveRecord::Migration[5.0]
  def change
    add_column :organizations, :updated_by, :integer
  end
end
