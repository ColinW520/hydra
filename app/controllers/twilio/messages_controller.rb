class Twilio::MessagesController < Twilio::BaseController
  def create
    Twilio::Messages::ReceivingWorker.perform_async(twilio_message_params.to_h)
  end

private

  def twilio_message_params
    params.permit([:ToCountry, :ToState, :SmsMessageSid, :NumMedia, :ToCity, :FromZip, :SmsSid, :FromState, :SmsStatus, :FromCity, :Body, :FromCountry, :To, :ToZip, :NumSegments, :MessageSid, :AccountSid, :From, :ApiVersion])
  end
end


# with media

# {"ToCountry"=>"US"
#    "MediaContentType0"=>"image/jpeg"
#     "ToState"=>"MN"
#      "SmsMessageSid"=>"MMf051f6141dc90b1994642d1c0449c84d"
#       "NumMedia"=>"1"
#        "ToCity"=>"ST CROIX BEACH"
#         "FromZip"=>"67218"
#          "SmsSid"=>"MMf051f6141dc90b1994642d1c0449c84d"
#           "FromState"=>"KS"
#            "SmsStatus"=>"received"
#             "FromCity"=>"WICHITA"
#              "Body"=>"Test2"
#               "FromCountry"=>"US"
#                "To"=>"+16513215934"
#                 "ToZip"=>"55043"
#                  "NumSegments"=>"1"
#                   "MessageSid"=>"MMf051f6141dc90b1994642d1c0449c84d"
#                    "AccountSid"=>"ACc7e87d0912e268b9cb24fcd1989fc46a"
#                     "From"=>"+13162588774"
#                      "MediaUrl0"=>"https://api.twilio.com/2010-04-01/Accounts/ACc7e87d0912e268b9cb24fcd1989fc46a/Messages/MMf051f6141dc90b1994642d1c0449c84d/Media/MEfc663e584849df6ebc6db00a7fbd3500"
#                       "ApiVersion"=>"2010-04-01"}
