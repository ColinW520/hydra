class Twilio::AuthorizationsController < Twilio::BaseController
  def authorize
    @organization = Organization.find params['state']
    @organization.update_attribute(:twilio_auth_id, params['AccountSid'])
    store_feed_item(@organization, "Connected its Twilio Account")
    respond_to do |format|
      format.html {
        flash[:notice] = 'You have successfully connected your Twilio account and authorized Aptexx Hydra to make charges on your behalf. Thanks!'
        redirect_to connect_organization_path(@organization)
      }
    end
  end

  def deauthorize
    organization = Organization.where(account_sid: params['AccountSid'])
    organization.update_attribute(:twilio_auth_id, nil)
    # TODO: We need a mailer here to inform A) us and B) them.
    store_feed_item(@organization, "Disconnected its Twilio Account")
  end
end
