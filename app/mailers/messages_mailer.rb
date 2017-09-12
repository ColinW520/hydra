class MessagesMailer < ApplicationMailer
  default template_path: "mailers/messages"

  def alert(message_id, user_id)
    @message = Message.find message_id
    @contact = @message.contact
    @user = User.find user_id

    mail to: @user.email, subject: "You have a new message from: #{@message.contact.full_name} on your TMT line: #{@message.line.name}."
  end

  def weekly_summary(user_id)
    @user = User.find user_id
    @stats = { inbound_messages: @user.organization.messages.inbound.where(created_at: 1.week.ago..Time.now).count, outbound_messages: @user.organization.message_requests.where(created_at: 1.week.ago..Time.now) }

    return if @stats[:inbound_messages] > 0 && @stats[:outbound_messages] > 0

    mail to: @user.email, subject: "Your weekly TextMy.Team messaging activity summary."
  end

  def daily_summary(user_id)
    @user = User.find user_id
    @stats = { inbound_messages: @user.organization.messages.inbound.where(created_at: 1.day.ago..Time.now).count, outbound_messages: @user.organization.message_requests.where(created_at: 1.day.ago..Time.now).count }

    return if @stats[:inbound_messages] > 0 && @stats[:outbound_messages] > 0

    mail to: @user.email, subject: "Your daily TextMy.Team messaging activity summary."
  end
end
