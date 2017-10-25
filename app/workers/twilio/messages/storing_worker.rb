class Twilio::Messages::StoringWorker < Twilio::BaseWorker
  def perform(twilio_sid, organization_id, line_id, contact_id, message_request_id = nil)
    @organization = Organization.find organization_id
    @line = Line.find line_id
    @contact = Contact.find contact_id
    @twilio_client = @organization.twilio_client
    @message = @twilio_client.messages.get twilio_sid

    # store it
    @local_message = Message.where(twilio_sid: @message.sid).first_or_initialize
    @local_message.sms_sid = @message.sid
    @local_message.twilio_sid = @message.sid
    @local_message.account_sid = @message.account_sid
    @local_message.line_id = @line.id
    @local_message.organization_id = @organization.id
    @local_message.contact_id = @contact.id
    @local_message.message_request_id = message_request_id
    @local_message.status = @message.status
    @local_message.direction = @message.direction == 'outbound-api' ? 'outbound' : 'inbound'
    @local_message.sent_at = Time.now
    @local_message.to = @message.to
    @local_message.from = @message.from
    @local_message.body = @message.body
    @local_message.error_message = @message.error_message
    @local_message.price_in_cents = @message.price.to_f.abs
    @local_message.num_media = @message.num_media
    @local_message.num_segments = @message.num_segments
    @local_message.save!

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
      return # hard return here, don't want to do anything else after this.
    end

    # handle starts
    if @local_message.body.squish == 'START'
      Twilio::Messages::StartHandlingWorker.perform_async(@local_message.id)
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
