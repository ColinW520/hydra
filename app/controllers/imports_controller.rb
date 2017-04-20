class ImportsController < ApplicationController
  before_action :set_import, only: [:show, :edit, :update, :destroy]

  def index
    @imports = Import.where(organization_id: current_user.organization_id).
                      order('created_at DESC').
                      limit(25)
  end

  def show
  end

  def new
    @import = Import.new(created_by: current_user.id, organization_id: current_user.organization_id)
  end

  def create
    @import = Import.create(import_params)

    respond_to do |format|
      if @import.save
        format.html {
          flash[:success] = 'Import enqueued for processing. We will let you know when its done.'
          redirect_to employees_path
        }
        format.json { head :no_content }
        format.js
      else
        format.html {
          flash[:danger] = "There were some problems with your import: #{@import.errors.full_messages}"
          redirect_to employees_path
        }
        format.json { render json: @import.errors.full_messages, status: :unprocessable_entity }
      end

    end
  end

private

  def set_import
  	@import = Import.find(params[:id])
    @organization = @import.organization
  end

  def import_params
    params.require(:import).permit!
  end

end
