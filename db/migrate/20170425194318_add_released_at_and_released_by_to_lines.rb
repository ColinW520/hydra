class AddReleasedAtAndReleasedByToLines < ActiveRecord::Migration[5.0]
  def change
    add_column :lines, :released_at, :datetime
    add_column :lines, :released_by, :string
  end
end
