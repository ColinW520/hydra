class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters
  layout :resolve_layout

  # DELETE /resource
  def destroy
    resource.soft_delete!
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :destroyed if is_flashing_format?
    yield resource if block_given?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end

  protected

    def configure_permitted_parameters
     #devise_parameter_sanitizer.permit(:first_name, :last_name, :organization_id, :mobile_phone, :email, :password, :password_confirmation, :current_password)
     devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :mobile_phone, :organization_id])
    end

    def after_update_path_for(resource)
      dashboard_path
    end

    def resolve_layout
      case action_name
      when "new", "create"
        "devise"
      else
        "application"
      end
    end
end
