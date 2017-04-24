class AddLineToMessages < ActiveRecord::Migration[5.0]
  def change
    add_reference :messages, :line, foreign_key: true, after: :organization_id
  end
end
