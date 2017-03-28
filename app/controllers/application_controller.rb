class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  load_and_authorize_resource
  before_action :authenticate_user!
end
