class Twilio::VoiceCallsController < Twilio::BaseController
  include Webhookable
  after_filter :set_header

  def create
    puts params

    response = Twilio::TwiML::Response.new do |r|
  	  r.Say 'Hi there! We only use this number for text messaging at this time. Please give', :voice => 'alice'
      r.Hangup
  	end

  	render_twiml response
  end
end

# https://463b06db.ngrok.io/twilio/voice_calls
