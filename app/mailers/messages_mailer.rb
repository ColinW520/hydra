class MessagesMailer < ApplicationMailer
  default template_path: "mailers/messages"

  def alert(message_id, user_id)
    @message = Message.find message_id
    @user = User.find user_id

    mail to: @user.email, subject: "You have a new message from: #{@message.contact.full_name} on your TMT line: #{@message.line.name}."
  end
end
