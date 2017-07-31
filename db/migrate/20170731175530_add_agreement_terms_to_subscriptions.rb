class AddAgreementTermsToSubscriptions < ActiveRecord::Migration[5.0]
  def change
    add_column :subscriptions, :spam_agreed, :boolean, default: false
    add_column :subscriptions, :terms_agreed, :boolean, default: false
    add_column :subscriptions, :signer_name, :string
  end
end
