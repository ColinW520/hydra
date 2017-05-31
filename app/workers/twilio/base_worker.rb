class Twilio::BaseWorker
  include Sidekiq::Worker
  sidekiq_options queue: :twilio

  def prepare_objects(organization_id)
    @organization = Organization.find organization_id
    @twilio_client = Twilio::REST::Client.new(@organization.twilio_auth_id, ENV['TWILIO_COLIN_AUTH_TOKEN'])
  end

  def perform
    raise 'Cannot call perform on Twilio::BaseWorker'
  end
end
