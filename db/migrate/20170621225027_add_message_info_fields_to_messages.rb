class AddMessageInfoFieldsToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :from_zip, :string
    add_column :messages, :from_city, :string
    add_column :messages, :from_country, :string
    add_column :messages, :from_state, :string
    add_column :messages, :num_segments, :integer
    add_column :messages, :num_media, :integer
    add_column :messages, :sms_sid, :string
  end
end
