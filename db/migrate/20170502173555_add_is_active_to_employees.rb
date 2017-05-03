class AddIsActiveToEmployees < ActiveRecord::Migration[5.0]
  def change
    add_column :employees, :is_active, :boolean, default: true
  end
end
