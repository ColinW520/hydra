class Twilio::Lines::ReleasingWorker < Twilio::BaseWorker
  include Sidekiq::Worker

  def perform(id, user_id)
    # setup what we need
    @line = Line.find line_id
    prepare_objects(@line.organization_id)

    # release the number
    twilio_number = @twilio_client.incoming_phone_numbers.delete(@line.twilio_id)

    # udpate the line
    @line.released_at = Time.now
    @line.released_by = user_id
    @line.twilio_id = nil
    @line.save! #save this ASAP.

  rescue => error
    @line.errors_count += 1
    @line.latest_error_message = error.message
    @line.save!
  end
end
