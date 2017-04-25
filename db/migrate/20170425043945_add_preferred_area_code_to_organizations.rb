class AddPreferredAreaCodeToOrganizations < ActiveRecord::Migration[5.0]
  def change
    add_column :organizations, :preferred_area_code, :string
  end
end
