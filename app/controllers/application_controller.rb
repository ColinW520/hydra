class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  #load_and_authorize_resource
  before_action :authenticate_user!, :set_xhr_flag
  after_filter :prepare_unobtrusive_flash

  def after_sign_in_path_for(resource)
    dashboard_path
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  protected

  def set_xhr_flag
    @xhr = request.xhr?
  end

  def configure_permitted_parameters
   devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :organization_id])
  end
end
