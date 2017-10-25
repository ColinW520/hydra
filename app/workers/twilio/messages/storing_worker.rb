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
      price_in_cents: @message.price.to_f.abs,
      num_media: @message.num_media,
      num_segments: @message.num_segments
    )

    # now store any media
    if @local_message.present? && @local_message.num_media > 0
      @message.media.list.each do |media_link|
        the_link = "https://api.twilio.com" + media_link.uri.remove('.json')
        MediaLink.where(link: the_link).first_or_create(
          message_id: @local_message.id,
          twilio_message_sid: @message.sid,
          twilio_file_type: media_link.content_type,
          link: the_link,
          direction: @message.direction == 'outbound-api' ? 'outbound' : 'inbound'
        )
      end
    end

    @contact.touch(:last_messaged_at)

    # handle optouts
    if %w(STOP STOPALL UNSUBSCRIBE CANCEL END QUIT REMOVE).include? @local_message.body.squish
      Twilio::Messages::StopHandlingWorker.perform_async(@local_message.id)
      # @contact.update_attributes(opted_out_at: Time.now, is_active: false)
      return # hard return here, don't want to do anything else after this.
    end

    # handle starts
    if %w(START).include? @message.body.squish
      Twilio::Messages::StartHandlingWorker.perform_async(@local_message.id)
      # @contact.update_attributes(opted_out_at: Time.now, is_active: false)
    end

    # handle alerts
    if @local_message.direction == 'inbound' && !@local_message.alerts_sent?
      store_feed_item(@local_message, "The #{@local_message.line.name} received a message from #{@contact.try(:full_name)} (#{@local_message.from}):")
      @organization.users.subscribed_to_instant_alerts.pluck(:id).each do |user_id|
        MessagesMailer.alert(@local_message.id, user_id).deliver_later
      end
      @local_message.update_attribute(:alerts_sent, true)
    end
  end
end
