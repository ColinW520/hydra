class Twilio::AuthorizationsController < ApplicationController
  layout false

  def authorize
    organization = Organization.find params['state']
    organization.update_attribute(:twilio_auth_id, params['AccountSid'])

    flash[:notice] = 'You have successfully connected your Twilio account and authorized us to make charges on your behalf. Thanks!'
    redirect_to organization_path(organization)
  end

  def deauthorize
    organization = Organization.where(twilio_auth_id: params['AccountSid'])
    organization.update_attribute(:twilio_auth_id, nil)
  end
end
