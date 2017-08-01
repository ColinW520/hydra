class Twilio::Lines::ReleasingWorker < Twilio::BaseWorker
  include Sidekiq::Worker

  def perform(id, user_id)
    @line = Line.find id
    prepare_objects(@line.organization_id)

    @twilio_client.account.incoming_phone_numbers.get(@line.twilio_id).delete

    @line.released_at = Time.now
    @line.released_by = user_id
    @line.twilio_id = nil
    @line.save!
  end
end
