class ApplicationController < ActionController::Base
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper
  protect_from_forgery with: :exception, prepend: true

  before_action :authenticate_user!, :set_xhr_flag, :gon_setup, :set_subnav
  after_action :prepare_unobtrusive_flash
  layout -> (controller) { controller.request.xhr? ? false : 'application' }

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

  def gon_setup
    gon.organization_id = current_user.try(:organization_id)
    gon.organization_slug = current_user.try(:organization).try(:slug)
    gon.stripe_publishable_key = ENV['STRIPE_PUBLISHABLE_KEY']
  end

  def set_subnav
    @subnav = controller_name
  end

  def configure_permitted_parameters
   devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :organization_id])
  end
end
