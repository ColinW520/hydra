class CancelledAtToOrganizations < ActiveRecord::Migration[5.0]
  def change
    add_column :organizations, :canceled_by, :integer
    add_column :organizations, :canceled_at, :datetime
  end
end
