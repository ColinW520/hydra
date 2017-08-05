class Twilio::CallbacksController < Twilio::BaseController
  def status
    @line = Line.find_by_number params['To']
    @contact = Contact.where(mobile_phone: params['From'], organization_id: @line.organization_id).first_or_create

    # store this
    Twilio::Messages::StoringWorker.perform_async(params['SmsMessageSid'], @line.organization_id, @line.id, @contact.id)
  end
end
