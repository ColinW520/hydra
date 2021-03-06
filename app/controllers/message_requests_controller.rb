class MessageRequestsController < ApplicationController
  before_action :set_message_request, only: [:show]

  def index
    message_requests_scope = current_user.organization.message_requests

    respond_to do |format|
      format.html { smart_listing_create :message_requests, message_requests_scope, partial: 'message_requests/listing', default_sort: { created_at: :desc }, page_sizes: [25, 50, 100, 150, 200] }
      format.js { smart_listing_create :message_requests, message_requests_scope, partial: 'message_requests/listing', default_sort: { created_at: :desc }, page_sizes: [25, 50, 100, 150, 200] }
      format.csv { send_data message_requests_scope.to_csv, filename: "messages_composed_as_of-#{Time.now}.csv" }
    end
  end

  def show
    @contact_ids = @message_request.expected_recipients.pluck(:id)
  end

  def new
    @subnav = 'compose'
    @query = params[:query].present? ? params[:query] : Hash.new
    @query[:id] = params[:contact_ids] if params[:contact_ids].present?

    gon.recipients_count & @expected_count = params[:count] ||= params[:contact_ids].count
    @message_request = MessageRequest.new
  end

  def create
    @message_request = MessageRequest.create(message_params)

    respond_to do |format|
      if @message_request.save
        store_feed_item(@message_request, "#{current_user.try(:first_name).try(:titleize)} sent a message to #{@message_request.recipients_count} contacts from the #{@message_request.line.name} line:")
        format.json { head :no_content }
        format.js {
          flash[:success] = 'Message Request has been queued for sending! It will go out ASAP.'
          redirect_to message_requests_path
        }
        format.html {
          flash[:success] = 'Message Request has been queued for sending! It will go out ASAP.'
          redirect_to message_requests_path
        }
      else
        format.html {
          flash[:success] = 'There were some issues with your message...'
          redirect_to message_requests_path
        }
        format.json { render json: { error_message_requests:  @message_request.errors.full_messages }, status: :unprocessable_entity }
        format.js { render json: { error_message_requests:  @message_request.errors.full_messages }, status: :unprocessable_entity }
      end

    end
  end

  private
    def set_message_request
      @message_request = MessageRequest.find(params[:id])
    end

    def message_params
      params.require(:message_request).permit!
    end
end
