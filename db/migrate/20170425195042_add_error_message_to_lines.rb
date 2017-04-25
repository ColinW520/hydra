class AddErrorMessageToLines < ActiveRecord::Migration[5.0]
  def change
    add_column :lines, :errors_count, :integer
    add_column :lines, :latest_error_message, :string
  end
end
