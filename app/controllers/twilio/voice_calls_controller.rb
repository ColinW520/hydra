class Twilio::VoiceCallsController < Twilio::BaseController
  include Webhookable
  after_filter :set_header

  def create
    @line = Line.find_by_number params[:Called]

    if @line.nil?
      response = Twilio::TwiML::Response.new do |r|
    	  r.Reject
    	end
    end

    if @line.forwarding_enabled? && @line.forwarding_number.present?
      response = Twilio::TwiML::Response.new do |r|
        r.Dial @line.forwarding_number
      end
    else
      response = Twilio::TwiML::Response.new do |r|
    	  r.Say 'Hi there! We only use this number for text messaging at this time. Please give', :voice => 'alice'
        r.Hangup
    	end
    end

    Twilio::Calls::LoggingWorker.perform_async(twilio_call_params.to_h)
  	render_twiml response
  end

  private

  def twilio_call_params
    params.permit([:Called, :ToState, :CallerCountry, :Direction, :CallerState, :ToZip, :CallSid, :To, :CallerZip, :ToCountry, :ApiVersion, :CalledZip, :CalledCity, :CallStatus, :From, :AccountSid, :CalledCountry, :CallerCity, :Caller, :FromCountry, :ToCity, :FromCity, :CalledState, :FromZip, :FromState])
  end
end
