class OrganizationsController < ApplicationController
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  def index
    redirect_to organization_path(current_user.organization_id) if current_user && current_user.organization_id.present?

    smart_listing_create :organizations,
                         Organization.accessible_by(current_ability),
                         partial: "organizations/listing",
                         default_sort: { created_at: "desc" }
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def find_organization
    @organization = Organization.find(params[:id])
  end

  def organization_params
    params.require(:organization).permit!
  end
end
