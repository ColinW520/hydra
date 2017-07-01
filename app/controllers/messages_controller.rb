class MessagesController < ApplicationController
  def index
    messages_scope = Message.filter_by(params.merge(organization_id: current_user.organization_id))

    sort_columns = [
      [:date, 'messages.sent_at'],
      [:direction, 'messages.direction'],
      [:name, 'contacts.first_name'],
      [:to, 'messages.to'],
      [:from, 'messages.from'],
      [:cost, 'message.price_in_cents']
    ]

    respond_to do |format|
      format.html { smart_listing_create :messages, messages_scope, partial: 'messages/listing', sort_attributes: sort_columns, default_sort: { sent_at: :desc }, page_sizes: [25, 50, 100, 150, 200] }
      format.js { smart_listing_create :messages, messages_scope, partial: 'messages/listing', sort_attributes: sort_columns, default_sort: { sent_at: :desc }, page_sizes: [25, 50, 100, 150, 200] }
      format.csv { send_data messages_scope.to_csv, filename: "messages_as_of-#{Time.now}.csv" }
    end
  end
end
