class Users::InvitationsController < Devise::InvitationsController
  before_action :set_sanitized_params, only: :create
  before_action :update_sanitized_params, only: :update

  layout :resolve_layout

  # PUT /resource/invitation
  def update
    respond_to do |format|
      format.js do
        invitation_token = Devise.token_generator.digest(resource_class, :invitation_token, update_resource_params[:invitation_token])
        self.resource = resource_class.where(invitation_token: invitation_token).first
        resource.skip_password = true
        resource.update_attributes update_resource_params.except(:invitation_token)
      end
      format.html do
        super
      end
    end
  end

  protected

  def set_sanitized_params
    devise_parameter_sanitizer.permit(:invite, keys: [:email, :first_name, :last_name, :mobile_phone, :organization_id, :admin_role])
  end

  def update_sanitized_params
    devise_parameter_sanitizer.permit(:accept_invitation, keys: [:first_name, :last_name, :password, :password_confirmation, :invitation_token, :mobile_phone, :organization_id, :admin_role])
  end

  def after_invite_path_for(resource)
    if current_inviter.admin_role?
      flash[:notice] = 'Invitation Sent'
      organization_users_path(current_inviter.organization)
    else
      after_sign_in_path_for(current_inviter)
    end
  end

  def resolve_layout
    if action_name == "edit"
      "devise"
    else
      "application"
    end
  end
end
