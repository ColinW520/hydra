class ChangeAccountSidToString < ActiveRecord::Migration[5.0]
  def change
    change_column :messages, :account_sid, :string
  end
end
