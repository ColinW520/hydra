class Twilio::Lines::BuyingWorker < Twilio::BaseWorker
  include Sidekiq::Worker

  def perform(id)
    # setup what we need
    @line = Line.find id
    prepare_objects(@line.organization_id)

    # purchase the number from twilio
    twilio_number = @twilio_client.incoming_phone_numbers.create(
      friendly_name: @line.name,
      phone_number: @line.number,
      sms_url: "https://aptexx-hydra.herokuapp.dev/twilio/messages",
      voice_url: "https://aptexx-hydra.herokuapp.dev/twilio/voice_calls",
    )

    # NOTE WE REALLY NEED TO UPDATE THIS TO DEAL WITH NUMBER NOT AVAILABLE ERROS

    # udpate the line
    @line.twilio_id = twilio_number.sid
    @line.save! #save this ASAP.
  end
end
