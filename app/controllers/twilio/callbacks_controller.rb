class Twilio::CallbacksController < Twilio::BaseController
  def status
    # this is only called on sent messages at this time.
    @line = Line.find_by_number params['From']
    @contact = Contact.where(mobile_phone: params['To'], organization_id: @line.organization_id).first

    # store this. we want an error to pop if we dont have a contact or a line.
    Twilio::Messages::StoringWorker.perform_async(params['messageSid'], @line.organization_id, @line.id, @contact.id)
  end
end


# smsSid: "SM15500a7fcee74adf91af1f549cd41b52"
# smsStatus: "sent"
# messageStatus: "sent"
# to: "+13162588774"
# messageSid: "SM15500a7fcee74adf91af1f549cd41b52"
# accountSid: "ACc7e87d0912e268b9cb24fcd1989fc46a"
# from: "+16513215934"
# apiVersion: "2010-04-01"
# controller: "twilio/callbacks"
# action: "status"
