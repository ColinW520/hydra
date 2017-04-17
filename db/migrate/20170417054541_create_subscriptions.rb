class CreateSubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :subscriptions do |t|
      t.references :organization, foreign_key: true
      t.string :stripe_plan_id
      t.string :stripe_customer_id
      t.integer :created_by
      t.integer :canceled_by
      t.string :coupon_code

      t.timestamps
    end
  end
end
