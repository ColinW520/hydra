class StaticPagesController < ApplicationController
  layout 'static_views'
  skip_before_action :authenticate_user!

  def home
  end

  def contact
  end

  def pricing
  end

  def terms
  end
  
  def privacy
  end
  
end
