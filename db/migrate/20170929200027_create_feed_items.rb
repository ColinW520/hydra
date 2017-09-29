class CreateFeedItems < ActiveRecord::Migration[5.0]
  def change
    create_table :feed_items do |t|
      t.references :organization, foreign_key: true
      t.references :user, foreign_key: true
      t.references :parent, polymorphic: true
      t.string :phrase

      t.timestamps
    end
  end
end
