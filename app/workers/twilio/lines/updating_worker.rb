class Twilio::Lines::UpdatingWorker < Twilio::BaseWorker
  include Sidekiq::Worker

  def perform(id)
    # setup what we need
    @line = Line.find id
    prepare_objects(@line.organization_id)

    # grab the Twilio instance
    @twilio_number = @twilio_client.incoming_phone_numbers.get(@line.twilio_id)

    # synchronize it with what we stored in our DB
    @twilio_number.update(
      friendly_name: @line.name,
      sms_url: "https://www.textmy.team/twilio/messages",
      voice_url: "https://www.textmy.team/twilio/voice_calls",
    )
  end
end
