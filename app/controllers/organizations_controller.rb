class OrganizationsController < ApplicationController
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  before_filter :find_organization, except: [:index, :new, :create]

  def index
    smart_listing_create :organizations,
                         Organization.accessible_by(current_ability),
                         partial: "organizations/listing",
                         default_sort: { created_at: "desc" }
  end

  def new
    @organization = Organization.new()
  end

  def create
    @organization = Organization.create(organization_params)

    respond_to do |format|
      if @organization.save
        format.json { head :no_content }
        format.js { flash.now[:success] = 'Organization has been created.' }
      else
        format.json { render json: @solution.errors.full_messages, status: :unprocessable_entity }
      end

    end
  end

  def show

  end

  def edit

  end

  def update
    respond_to do |format|
      if @organization.update(organization_params)
        format.html {
          flash[:sucess] = 'Organization has been updated!'
          redirect_to organizations_path
        }
        format.json { head :no_content }
        format.js { flash.now[:success] = 'Organization has been updated.' }
      else
        format.json { render json: @organization.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @organization.soft_delete!
    sign_out_and_redirect(@organization)
    respond_to do |format|
      format.js { flash.now[:success] = 'Organization removed and can no longer access account.' }
      format.html { redirect_to organizations_path, notice: 'Organization removed.' }
      format.json { head :no_content }
    end
  end

  def restore

  end

  private

  def find_organization
    @organization = Organization.find(params[:id])
  end

  def organization_params
    params.require(:organization).permit!
  end
end
