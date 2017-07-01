class Twilio::MessagesController < Twilio::BaseController
  def create
    twilio_params = params
    Twilio::Messages::ReceivingWorker.new.perform(params) if Rails.env.development?
    Twilio::Messages::ReceivingWorker.perform_async(params) if Rails.env.production?
  end

private

  def twilio_message_params
    params.permit(["ToCountry", "ToState", "SmsMessageSid", "NumMedia", "ToCity", "FromZip", "SmsSid", "FromState", "SmsStatus", "FromCity", "Body", "FromCountry", "To", "ToZip", "NumSegments", "MessageSid", "AccountSid", "From", "ApiVersion"]).to_h
  end
end
