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
      phone_number: @line.number,
      sms_url: "https://aptexx-hydra.herokuapp.com/twilio/messages",
      voice_url: "https://aptexx-hydra.herokuapp.com/twilio/voice_calls",
    )
  end
end
