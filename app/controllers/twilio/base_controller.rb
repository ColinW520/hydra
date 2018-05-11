class Twilio::BaseController < ActionController::Base
  include ApplicationHelper
  require 'twilio-ruby'
  layout false
end
