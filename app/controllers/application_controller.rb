class ApplicationController < ActionController::Base
  include ApplicationHelper
  before_action :configure_permitted_parameters, if: :devise_controller?
  after_action :track_action

  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper
  protect_from_forgery with: :exception, prepend: true

  before_action :authenticate_user!, :set_xhr_flag, :gon_setup, :set_subnav
  after_action :prepare_unobtrusive_flash
  layout -> (controller) { controller.request.xhr? ? false : 'application' }

  def track_action
    ahoy.track "Viewed#{controller_name} ##{action_name}" unless request.xhr?
  end

  def after_sign_in_path_for(resource)
    feed_items_path
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  def require_admin!
    unless current_user && current_user.is_super_user?
      flash[:alert] = 'Sorry, that action is only available to Super Users.'
      redirect_to root_path
    end
  end
  helper_method :require_admin!

  protected

  def set_xhr_flag
    @xhr = request.xhr?
  end

  def gon_setup
    @current_organization = current_user.try(:organization)
    @current_subscription = @current_organization.try(:subscription)
    @current_plan = @current_subscription.try(:plan)
    gon.organization_id = current_user.try(:organization_id)
    gon.organization_slug = current_user.try(:organization).try(:slug)
    gon.stripe_publishable_key = ENV['STRIPE_PUBLISHABLE_KEY']
  end

  def set_subnav
    @subnav = controller_name
  end

  def configure_permitted_parameters
   the_keys = [:first_name, :last_name, :mobile_phone, :organization_id, :admin_role, :notify_instantly, :summarize_daily, :summarize_weekly]
   devise_parameter_sanitizer.permit(:sign_up, keys: the_keys)
   devise_parameter_sanitizer.permit(:accunt_update, keys: the_keys)
  end
end
