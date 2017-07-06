class MessagesMailer < ApplicationMailer
  default template_path: "mailers/messages"

  def alert(message_id)
    @message = Message.find message_id
    @line = @message.line
    @contact = @message.contact

    mail to: @line.email_alert_address, subject: "Your #{@line.name} line has a new message."
  end
end
