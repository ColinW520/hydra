class AddSuperUserRoleToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :is_super_user, :boolean, default: false
    remove_column :users, :supervisor_role
  end
end
