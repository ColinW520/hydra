class AddTimezoneToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :timezone, :string, default: 'Pacific Time (US & Canada)'
  end
end
