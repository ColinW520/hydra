class Twilio::AuthorizationsController < Twilio::BaseController
  def authorize
    @organization = Organization.find params['state']
    @organization.update_attribute(:twilio_auth_id, params['AccountSid'])

    respond_to do |format|
      format.html {
        flash[:notice] = 'You have successfully connected your Twilio account and authorized Aptexx Hydra to make charges on your behalf. Thanks!'
        redirect_to root_path
      }
    end
  end

  def deauthorize
    organization = Organization.where(twilio_auth_id: params['AccountSid'])
    organization.update_attribute(:twilio_auth_id, nil)
  end
end
