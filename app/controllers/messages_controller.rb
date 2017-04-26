class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  # GET /messages
  # GET /messages.json
  def index
    messages_scope = Message.includes(:organization, :message_recipients)

    respond_to do |format|
      format.html { smart_listing_create :messages, messages_scope, partial: 'messages/listing', default_sort: { created_at: :desc }, page_sizes: [25, 50, 100, 150, 200] }
      format.js { smart_listing_create :messages, messages_scope, partial: 'messages/listing', default_sort: { created_at: :desc }, page_sizes: [25, 50, 100, 150, 200] }
      #format.csv { messages_scope.to_csv, filename: "messages_as_of-#{Time.now}.csv" }
    end
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @expected_count = params[:count] ||= params[:employee_ids].count
    query = params[:query] if params[:query].present?
    query = {id: params[:employee_ids]} if params[:employee_ids].present?
    @message = Message.new(organization_id: current_user.organization_id, user_id: current_user.id, filter_query: query)
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.create(message_params)

    respond_to do |format|
      if @message.save
        format.json { head :no_content }
        format.js {
          flash[:success] = 'Message has been queued for sending! It will go out ASAP.'
          redirect_to messages_path
        }
        format.html {
          flash[:success] = 'Message has been created.'
          redirect_to messages_path
        }
      else
        format.html {
          flash[:success] = 'There were some errors with your message...'
          redirect_to messages_path
        }
        format.json { render json: { error_messages:  @message.errors.full_messages }, status: :unprocessable_entity }
        format.js { render json: { error_messages:  @message.errors.full_messages }, status: :unprocessable_entity }
      end

    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html {
          flash[:sucess] = 'Message has been updated!'
          redirect_to messages_path
        }
        format.json { head :no_content }
        format.js { flash[:success] = 'Message has been updated.' }
      else
        format.json { render json: @message.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit!
    end
end
