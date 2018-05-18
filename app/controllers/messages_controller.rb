class MessagesController < ApplicationController
  def index
    messages_scope = current_user.organization.messages.filter_by(params)

    sort_columns = [
      [:date, 'messages.created_at'],
      [:direction, 'messages.direction'],
      [:name, 'contacts.first_name'],
      [:to, 'messages.to'],
      [:from, 'messages.from']
    ]

    respond_to do |format|
      format.html {
        smart_listing_create :messages,
        messages_scope,
        partial: 'messages/listing',
        default_sort: { created_at: 'DESC' },
        page_sizes: [25, 50, 100, 150, 200]
      }
      format.js {
        smart_listing_create :messages,
        messages_scope,
        partial: 'messages/listing',
        default_sort: { created_at: 'DESC' },
        page_sizes: [25, 50, 100, 150, 200]
      }
      format.csv { send_data messages_scope.order(date: 'DESC').to_csv, filename: "messages_as_of-#{Time.now}.csv" }
    end

    def show
      @message = Message.find(params[:id])
    end
  end
end
