class Twilio::Messages::StoringWorker < Twilio::BaseWorker

  def perform(twilio_sid, organization_id, line_id, contact_id, message_request_id = nil)
    @organization = Organization.find organization_id
    @line = Line.find line_id
    @contact = Contact.find contact_id
    @twilio_client = @organization.twilio_client
    @message = @twilio_client.messages.get twilio_sid

    # store it
    @local_message = Message.where(twilio_sid: @message.sid).first_or_create(
      sms_sid: @message.sid,
      twilio_sid: @message.sid,
      account_sid: @message.account_sid,
      line_id: @line.id,
      organization_id: @organization.id,
      contact_id: @contact.id,
      message_request_id: message_request_id,
      status: @message.status,
      direction: @message.direction == 'outbound-api' ? 'outbound' : 'inbound',
      sent_at: Time.now,
      to: @message.to,
      from: @message.from,
      body: @message.body,
      error_message: @message.error_message,
      price_in_cents: @message.price.to_f.abs.to_s,
      num_media: @message.num_media,
      num_segments: @message.num_segments
    )

    # this is where we would need to store any message links if needed
    @contact.touch(:last_messaged_at)

    # handle optouts
    if %w(STOP STOPALL UNSUBSCRIBE CANCEL END QUIT REMOVE).include? @message.body.squish
      @contact.update_attributes(opted_out_at: Time.now, is_active: false)
    end

    # handle alerts
    if @message.direction == 'inbound' && !@message.alerts_sent?
      @organization.users.subscribed_to_instant_alerts.pluck(:id).each do |user_id|
        MessagesMailer.alert(@message.id, user_id).deliver_later
      end
    end
  end
end
