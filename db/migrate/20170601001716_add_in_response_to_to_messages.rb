class AddInResponseToToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :in_response_to, :string
  end
end
