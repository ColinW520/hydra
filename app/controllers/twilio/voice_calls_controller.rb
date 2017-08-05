class Twilio::VoiceCallsController < Twilio::BaseController
  include Webhookable
  after_filter :set_header

  def create
    # we always do this.
    Twilio::Calls::LoggingWorker.perform_async(twilio_call_params.to_h)

    @line = Line.find_by_number params[:Called]
    voice_response = @line.voice_auto_response ||= "Hi there! We only use this number for text messaging at this time."

    # this should really, never, ever happen
    if @line.reject_voice_calls
      @response = Twilio::TwiML::Response.new do |r|
    	  r.Reject
    	end
    else
      @response = Twilio::TwiML::Response.new do |r|
    	  r.Say(@line.voice_auto_response, voice: 'alice') if @line.voice_auto_response.present?
        r.Dial(@line.forwarding_number) if @line.forwarding_number.present?
    	end
    end

  	render_twiml @response
  end

  private

  def twilio_call_params
    params.permit([:Called, :ToState, :CallerCountry, :Direction, :CallerState, :ToZip, :CallSid, :To, :CallerZip, :ToCountry, :ApiVersion, :CalledZip, :CalledCity, :CallStatus, :From, :AccountSid, :CalledCountry, :CallerCity, :Caller, :FromCountry, :ToCity, :FromCity, :CalledState, :FromZip, :FromState])
  end
end
