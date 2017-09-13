class MessagesMailer < ApplicationMailer
  default template_path: "mailers/messages"

  def alert(message_id, user_id)
    @message = Message.find message_id
    @contact = @message.contact
    @user = User.find user_id

    mail to: @user.email, subject: "You have a new message from: #{@message.contact.full_name} on your TMT line: #{@message.line.name}."
  end

  def weekly_summary(user_id)
    range = 1.week.ago.beginning_of_day..Time.now.beginning_of_day
    @user = User.find user_id
    @stats = {
      inbound_messages: @user.organization.messages.inbound.where(range).count,
      outbound_messages: @user.organization.message_requests.where(range).count,
      outbound_sent:  @user.organization.messages.outbound.where(range).count
    }

    return unless @stats[:inbound_messages] > 0 && @stats[:outbound_messages] > 0

    mail to: @user.email, subject: "Your weekly TextMy.Team messaging activity summary."
  end

  def daily_summary(user_id)
    range = 1.day.ago.beginning_of_day..Time.now.beginning_of_day
    @user = User.find user_id
    @stats = {
      inbound_messages: @user.organization.messages.inbound.where(range).count,
      outbound_messages: @user.organization.message_requests.where(range).count,
      outbound_sent:  @user.organization.messages.outbound.where(range).count
    }
    return unless @stats[:inbound_messages] > 0 && @stats[:outbound_messages] > 0

    mail to: @user.email, subject: "Your daily TextMy.Team messaging activity summary."
  end
end
