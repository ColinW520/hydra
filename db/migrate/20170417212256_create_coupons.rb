class CreateCoupons < ActiveRecord::Migration[5.0]
  def change
    create_table :coupons do |t|
      t.string :stripe_id
      t.string :code
      t.integer :percent_off

      t.timestamps
    end
  end
end
