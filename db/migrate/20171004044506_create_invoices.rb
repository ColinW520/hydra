class CreateInvoices < ActiveRecord::Migration[5.0]
  def change
    create_table :invoices do |t|
      t.string :stripe_id
      t.integer :amount_due
      t.integer :attempt_count
      t.boolean :attempted
      t.string :billing
      t.string :charge_id
      t.boolean :closed
      t.string :currency
      t.string :customer_id
      t.datetime :date
      t.string :description
      t.string :discount_code
      t.integer :ending_balance
      t.boolean :forgiven
      t.string :number
      t.boolean :paid
      t.datetime :period_end
      t.datetime :period_start
      t.string :receipt_number
      t.string :statement_descriptor
      t.string :subscription_id
      t.integer :subtotal
      t.integer :total

      t.timestamps
    end
  end
end
