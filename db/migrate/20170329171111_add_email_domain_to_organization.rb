class AddEmailDomainToOrganization < ActiveRecord::Migration[5.0]
  def change
    add_column :organizations, :email_domain, :string, unique: true
  end
end
