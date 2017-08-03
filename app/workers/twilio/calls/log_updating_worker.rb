class Twilio::Calls::LogUpdatingWorker < Twilio::BaseWorker
  def perform(log_id)
    @log = CallLog.find log_id
    prepare_objects(@log.organization_id)

    return if @log.line.released_at.present?

    @call = @twilio_client.calls.get(@log.call_sid)

    @log.update_attributes(
      duration_in_seconds: @call.duration.to_i,
      price_in_cents: @call.price.to_f.abs,
      answered_by: @call.answered_by
    )
  end
end
