class MessageRequestsController < ApplicationController
  before_action :set_message_request, only: [:show]

  def index
    message_requests_scope = MessageRequest.includes(:organization)

    respond_to do |format|
      format.html { smart_listing_create :message_requests, message_requests_scope, partial: 'message_requests/listing', default_sort: { created_at: :desc }, page_sizes: [25, 50, 100, 150, 200] }
      format.js { smart_listing_create :message_requests, message_requests_scope, partial: 'message_requests/listing', default_sort: { created_at: :desc }, page_sizes: [25, 50, 100, 150, 200] }
      # format.csv { message_requests_scope.to_csv, filename: "message_requests_as_of-#{Time.now}.csv" }
    end
  end

  def show
  end

  def new
    @query = params[:query].present? ? params[:query] : Hash.new
    @query[:id] = params[:contact_ids] if params[:contact_ids].present?

    @expected_count = params[:count] ||= params[:contact_ids].count
    @message_request = MessageRequest.new
  end

  def create
    @message_request = MessageRequest.create(message_params)

    respond_to do |format|
      if @message_request.save
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
        format.json { render json: { error_message_requests:  @message_request.errors.full_message_requests }, status: :unprocessable_entity }
        format.js { render json: { error_message_requests:  @message_request.errors.full_message_requests }, status: :unprocessable_entity }
      end

    end
  end

  private
    def set_message
      @message_request = MessageRequest.find(params[:id])
    end

    def message_params
      params.require(:message_request).permit!
    end
end
