class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  def index
    messages_scope = Message.includes(:organization, :message_recipients)

    respond_to do |format|
      format.html { smart_listing_create :messages, messages_scope, partial: 'messages/listing', default_sort: { created_at: :desc }, page_sizes: [25, 50, 100, 150, 200] }
      format.js { smart_listing_create :messages, messages_scope, partial: 'messages/listing', default_sort: { created_at: :desc }, page_sizes: [25, 50, 100, 150, 200] }
      # format.csv { messages_scope.to_csv, filename: "messages_as_of-#{Time.now}.csv" }
    end
  end

  def show
  end

  def new
    @query = params[:query].present? ? params[:query] : Hash.new
    @query[:id] = params[:contact_ids] if params[:contact_ids].present?

    @expected_count = params[:count] ||= params[:contact_ids].count
    @message = Message.new
  end

  def create
    @message = Message.create(message_params)
    @message.user_id = current_user.id
    @message.organization_id = current_user.organization_id

    respond_to do |format|
      if @message.save
        format.json { head :no_content }
        format.js {
          flash[:success] = 'Message has been queued for sending! It will go out ASAP.'
          redirect_to messages_path
        }
        format.html {
          flash[:success] = 'Message has been queued for sending! It will go out ASAP.'
          redirect_to messages_path
        }
      else
        format.html {
          flash[:success] = 'There were some issues with your message...'
          redirect_to messages_path
        }
        format.json { render json: { error_messages:  @message.errors.full_messages }, status: :unprocessable_entity }
        format.js { render json: { error_messages:  @message.errors.full_messages }, status: :unprocessable_entity }
      end

    end
  end

  private
    def set_message
      @message = Message.find(params[:id])
    end

    def message_params
      params.require(:message).permit!
    end
end
