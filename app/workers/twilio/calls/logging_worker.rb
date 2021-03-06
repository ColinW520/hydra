class Twilio::Calls::LoggingWorker < Twilio::BaseWorker
  def perform(params)
    # Regardless of all else, we store these params
    @log = CallLog.new(
      direction: params['Direction'],
      account_sid: params['AccountSid'],
      call_sid: params['CallSid'],
      call_status: params['CallStatus'],
      called: params['Called'],
      called_state: params['CalledState'],
      called_zip: params['CalledZip'],
      called_city: params['CalledCity'],
      called_country: params['CalledCountry'],
      caller_country: params['CallerCountry'],
      caller_state: params['CallerState'],
      caller_zip: params['CallerZip'],
      caller_city: params['CallerCity'],
      caller: params['Caller'],
      to: params['To'],
      to_zip: params['ToZip'],
      to_state: params['ToState'],
      to_city: params['ToCity'],
      to_country: params['ToCountry'],
      from: params['From'],
      from_country: params['FromCountry'],
      from_city: params['FromCity'],
      from_zip: params['FromZip'],
      from_state: params['FromState'],
      api_version: params['ApiVersion']
    )

    # Assign this Call Log to a line we manage.
    @line = Line.find_by_number params['To']
    @log.line_id = @line.try(:id)
    @log.forwarded = true if @line.voice_forwarding_number.present?
    @log.forwarded_to = @line.voice_forwarding_number if @log.forwarded?
    @log.organization_id = @line.try(:organization_id)

    # Assign this CallLog to the appropriate organization's contact record, or create one for it, based on the mobile #
    @contact = Contact.where(mobile_phone: params['From'], organization_id: @line.organization_id).first_or_create
    @log.contact_id = @contact.try(:id)
    @log.save!

    store_feed_item(@log, "#{@log.line.try(:name)} received a phone call from #{@log.contact.try(:full_name)} (#{@log.from}).")

    Twilio::Calls::LogUpdatingWorker.perform_in(30.minutes, @log.id)
  end
end
