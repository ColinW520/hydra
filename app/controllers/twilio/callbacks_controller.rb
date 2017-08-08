class Twilio::CallbacksController < Twilio::BaseController
  def status
    # this is only called on sent messages at this time.
    raise 'NO SID' unless params['MessageSid'].present?
    @line = Line.find_by_number params['From']
    @contact = Contact.where(mobile_phone: params['To'], organization_id: @line.organization_id).first

    # store this. we want an error to pop if we dont have a contact or a line.
    Twilio::Messages::StoringWorker.perform_async(params['MessageSid'], @line.organization_id, @line.id, @contact.id)
  end
end
