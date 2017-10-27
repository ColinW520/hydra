class Twilio::Messages::ReceivingWorker < Twilio::BaseWorker

  def perform(params, links = [])
    @line = Line.find_by_number params['To']

    # create this contact if we haven't already
    @contact = Contact.where(mobile_phone: params['From'], organization_id: @line.organization_id).first_or_create

    # tag this contact if we haven't already

    # store this
    Twilio::Messages::StoringWorker.perform_async(params['SmsMessageSid'], @line.organization_id, @line.id, @contact.id)

    # q up auto response if needed
    Twilio::Messages::AutoResponseSendingWorker.perform_async(@line.id, @contact.id) if @line.sms_auto_response_text.present?
  end
end
