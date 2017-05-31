class MessageRecipientsController < ApplicationController
  before_action :set_message_recipient, only: [:show, :edit, :update, :destroy]

  def index
    @message_recipients = MessageRecipient.all
  end

  def show
  end

  private
    def set_message_recipient
      @message_recipient = MessageRecipient.find(params[:id])
    end

    def message_recipient_params
      params.require(:message_recipient).permit!
    end
end
