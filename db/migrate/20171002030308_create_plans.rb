class CreatePlans < ActiveRecord::Migration[5.0]
  def change
    create_table :plans do |t|
      t.string :stripe_id
      t.string :name
      t.integer :amount_in_cents
      t.integer :trial_period_days
      t.string :statement_descriptor
      t.boolean :can_add_users
      t.boolean :can_send_mms
      t.boolean :can_schedule_messages
      t.boolean :can_upload_contacts
      t.boolean :can_add_lines

      t.timestamps
    end
  end
end
