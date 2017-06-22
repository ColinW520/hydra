class AddTwilioSettingsToLines < ActiveRecord::Migration[5.0]
  def change
    add_column :lines, :voice_url, :string
    add_column :lines, :sms_url, :string
  end
end
