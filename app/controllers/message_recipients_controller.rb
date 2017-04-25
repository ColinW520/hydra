class MessageRecipientsController < ApplicationController
  before_action :set_message_recipient, only: [:show, :edit, :update, :destroy]

  # GET /message_recipients
  # GET /message_recipients.json
  def index
    @message_recipients = MessageRecipient.all
  end

  # GET /message_recipients/1
  # GET /message_recipients/1.json
  def show
  end

  # GET /message_recipients/new
  def new
    @message_recipient = MessageRecipient.new
  end

  # GET /message_recipients/1/edit
  def edit
  end

  # POST /message_recipients
  # POST /message_recipients.json
  def create
    @message_recipient = MessageRecipient.new(message_recipient_params)

    respond_to do |format|
      if @message_recipient.save
        format.html { redirect_to @message_recipient, notice: 'Message recipient was successfully created.' }
        format.json { render :show, status: :created, location: @message_recipient }
      else
        format.html { render :new }
        format.json { render json: @message_recipient.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /message_recipients/1
  # PATCH/PUT /message_recipients/1.json
  def update
    respond_to do |format|
      if @message_recipient.update(message_recipient_params)
        format.html { redirect_to @message_recipient, notice: 'Message recipient was successfully updated.' }
        format.json { render :show, status: :ok, location: @message_recipient }
      else
        format.html { render :edit }
        format.json { render json: @message_recipient.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /message_recipients/1
  # DELETE /message_recipients/1.json
  def destroy
    @message_recipient.destroy
    respond_to do |format|
      format.html { redirect_to message_recipients_url, notice: 'Message recipient was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message_recipient
      @message_recipient = MessageRecipient.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_recipient_params
      params.require(:message_recipient).permit(:message_id, :employee_id, :to_number, :from_number, :twilio_id, :sent_at, :error_message)
    end
end
