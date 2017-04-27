class Twilio::Lines::BuyingWorker < Twilio::BaseWorker
  include Sidekiq::Worker

  def perform(id)
    # setup what we need
    @line = Line.find line_id
    prepare_objects(@line.organization_id)

    # purchase the number from twilio
    twilio_number = @twilio_client.incoming_phone_numbers.create(phone_number: @line.number)

    # udpate the line
    @line.twilio_id = twilio_number.sid
    @line.save! #save this ASAP.

    # now, update the line with a few things.
    twilio_number.update(
      friendly_name: @line.name,
    )
    puts twilio_number.voice_url
  end
end
