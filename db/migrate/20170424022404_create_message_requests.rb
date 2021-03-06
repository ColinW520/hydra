class CreateMessageRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :message_requests do |t|
      t.references :user, foreign_key: true
      t.references :organization, foreign_key: true
      t.string :body
      t.integer :recipients_count
      t.datetime :processed_at

      t.timestamps
    end
  end
end
