class UsersController < ApplicationController
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  before_filter :find_user, except: [:index, :new, :create]

  def index
    smart_listing_create :users,
                         User.accessible_by(current_ability),
                         partial: "users/listing",
                         default_sort: { created_at: "desc" }
  end

  def destroy
    @user.destroy
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit!
  end
end
