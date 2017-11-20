class AddSendSignupNotificationsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :send_signup_notifications, :boolean, default: false
  end
end
