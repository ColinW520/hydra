class AddCustomVoiceResponseToLines < ActiveRecord::Migration[5.0]
  def change
    add_column :lines, :voice_auto_response, :string
    add_column :lines, :reject_voice_calls, :boolean, default: false
  end
end
