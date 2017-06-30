class Twilio::Messages::ReceivingWorker < Twilio::BaseWorker
  def perform(params)
    # Regardless of all else, we store these params
    @message = Message.new(
      direction: 'inbound',
      twilio_sid: params['SmsMessageSid'],
      sms_sid: params['SmsSid'],
      from: params['From'],
      to: params['To'],
      body: params['Body'],
      account_sid: params['AccountSid'],
      from_zip: params['FromZip'],
      from_city: params['FromCity'],
      from_state: params['FromState'],
      from_country: params['FromCountry'],
      num_media: params['NumMedia'],
      num_segments: params['NumSegments'],
      received_at: Time.now,
      price_in_cents: 0.0075
    )

    # Assign this to a line we manage.
    # Sound the alarm if we don't have a line for this number.
    @line = Line.find_by_number params['To']
    if @line.present?
      @message.line_id = @line.id
    else
      # sound the Alarm.
      return
    end

    @contact = Contact.where(mobile_phone: params['From'], organization_id: @line.organization_id).first_or_create
    @message.contact_id = @contact.id
    @message.save!
  end
end
