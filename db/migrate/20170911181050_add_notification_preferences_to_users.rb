class AddNotificationPreferencesToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :notify_instantly, :boolean, default: false
    add_column :users, :summarize_daily, :boolean, default: false
    add_column :users, :summarize_weekly, :boolean, default: false
  end
end
