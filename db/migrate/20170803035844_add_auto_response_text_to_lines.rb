class AddAutoResponseTextToLines < ActiveRecord::Migration[5.0]
  def change
    add_column :lines, :use_auto_response, :boolean, default: false
    add_column :lines, :sms_auto_response_text, :string
  end
end
