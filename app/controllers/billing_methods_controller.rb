class BillingMethodsController < ApplicationController
  before_action :find_billing_method, except: [:index, :new, :create]

  def index
    @organization = Organization.friendly.find params[:organization_id]
    billing_methods_scope = BillingMethod.includes(:organization)
    billing_methods_scope = billing_methods_scope.where(organization_id: params[:organization_id]) if params[:organization_id].present?

    smart_listing_create :billing_methods,
                        billing_methods_scope,
                        partial: "billing_methods/listing",
                        default_sort: { created_at: "desc" }
  end

  def new
    @organization = Organization.friendly.find(params[:organization_id]) if params[:organization_id]
    @billing_method = BillingMethod.new(organization_id: @organization.id)
  end

  def create
    @billing_method = BillingMethod.create(billing_method_params)

    respond_to do |format|
      if @billing_method.save
        format.json { head :no_content }
        format.js { flash[:success] = 'Billing Method has been created.' }
        format.html {
          flash[:success] = 'Your Billing Method has been created!'
          redirect_to organization_path(@billing_method.organization)
        }
      else
        format.json { render json: @billing_method.errors.full_messages, status: :unprocessable_entity }
      end

    end
  end

  def show

  end

  def edit

  end

  def update
    respond_to do |format|
      if @billing_method.update(billing_method_params)
        format.html {
          flash[:sucess] = 'Billing Method has been updated!'
          redirect_to organization_path(@organization)
        }
        format.json { head :no_content }
        format.js { flash[:success] = 'Billing Method has been updated.' }
      else
        format.json { render json: @billing_method.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @billing_method.soft_delete!(current_user.id)
    respond_to do |format|
      format.js { flash[:success] = 'BillingMethod removed.' }
      format.html { redirect_to organization_path(@organization), notice: 'BillingMethod removed.' }
      format.json { head :no_content }
    end
  end

  private

  def find_billing_method
    @organization = Organization.friendly.find(params[:organization_id]) if params[:organization_id]
    @billing_method = BillingMethod.find(params[:id]) if params[:id]
    gon.billing_method_id = @billing_method.id if @billing_method.present?
    gon.organization_id = @organization.id if @organization.present?
  end

  def billing_method_params
    params.require(:billing_method).permit!
  end
end
