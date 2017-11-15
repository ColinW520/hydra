class AddSignupTextToOrganizations < ActiveRecord::Migration[5.0]
  def change
    add_column :organizations, :signup_text, :string
  end
end
