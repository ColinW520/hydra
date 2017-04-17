class SubscriptionsController < ApplicationController
  before_action :find_subscription, except: [:index, :new, :create]

  def index
    @organization = Organization.friendly.find params[:organization_id]
    subscriptions_scope = Subscription.accessible_by(current_ability)
    subscriptions_scope = subscriptions_scope.where(organization_id: params[:organization_id]) if params[:organization_id].present?

    smart_listing_create :subscriptions,
                        subscriptions_scope,
                        partial: "subscriptions/listing",
                        default_sort: { created_at: "desc" }
  end

  def new
    @organization = Organization.friendly.find(params[:organization_id]) if params[:organization_id]
    @subscription = Subscription.new()
  end

  def create
    @subscription = Subscription.create(subscription_params)

    respond_to do |format|
      if @subscription.save
        format.json { head :no_content }
        format.js { flash[:success] = 'Subscription has been created.' }
        format.html do
          flash[:success] = 'Your Subscription has been created!'
          redirect_to organization_path(@subscription.organization)
        end
      else
        format.html do
          flash[:error] = @subscription.errors.full_messages
          redirect_to organization_path(params[:organization_id])
        end
        format.json { render json: @subscription.errors.full_messages, status: :unprocessable_entity }
      end

    end
  end

  def show

  end

  def edit

  end

  def update
    respond_to do |format|
      if @subscription.update(subscription_params)
        format.html {
          flash[:sucess] = 'Subscription has been updated!'
          redirect_to organization_path(@organization)
        }
        format.json { head :no_content }
        format.js { flash[:success] = 'Subscription has been updated.' }
      else
        format.json { render json: @subscription.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @subscription.soft_delete!(current_user.id)
    respond_to do |format|
      format.js { flash[:success] = 'Subscription removed.' }
      format.html { redirect_to organization_path(@organization), notice: 'Subscription removed.' }
      format.json { head :no_content }
    end
  end

  private

  def find_subscription
    @organization = Organization.friendly.find(params[:organization_id]) if params[:organization_id]
    @subscription = Subscription.find(params[:id]) if params[:id]
    gon.subscription_id = @subscription.id if @subscription.present?
    gon.organization_id = @organization.id if @organization.present?
  end

  def subscription_params
    params.require(:subscription).permit!
  end
end
