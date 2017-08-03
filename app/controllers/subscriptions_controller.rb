class SubscriptionsController < ApplicationController
  before_action :find_subscription, except: [:index, :new, :create]
  layout :resolve_layout

  def index
    @organization = Organization.friendly.find params[:organization_id]
    subscriptions_scope = @organization.subscriptions

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

    unless @subscription.terms_agreed
      respond_to do |format|
        format.js { flash[:danger] = 'You must agree to the terms.' }
        format.html do
          flash[:error] = 'You must agree to the terms.'
          redirect_to new_organization_subscription_path(@subscription.organization) and return
        end
      end
    end

    unless @subscription.spam_agreed
      respond_to do |format|
        format.js { flash[:error] = 'You must agree to the terms.' }
        format.html do
          flash[:error] = 'You must agree to our ANTI-Spam requirements.'
          redirect_to new_organization_subscription_path(@subscription.organization) and return
        end
      end
    end

    respond_to do |format|
      if @subscription.save
        format.json { head :no_content }
        format.js { flash[:success] = 'Subscription has been created.' }
        format.html do
          flash[:success] = 'Thank you for completing your subscription! Now you can add lines, contacts, and start sending messages.'
          redirect_to lines_path
        end
      else
        format.html do
          flash[:error] = @subscription.errors.full_messages
          redirect_to new_organization_subscription_path(@subscription.organization)
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
    @subscription.cancel_on_stripe!(current_user.id)
    @subscription.update_attributes(canceled_at: Time.now, canceled_by: current_user.id)
    respond_to do |format|
      format.js { flash[:success] = 'Subscription removed.' }
      format.html { redirect_to organization_path(@organization), notice: 'Subscription cancelled. You may continue to use Hydra until the present biling period ends.' }
      format.json { head :no_content }
    end
  end

  private

  def find_subscription
    @organization = Organization.friendly.find(params[:organization_id]) if params[:organization_id]
    @subscription = Subscription.find_by_stripe_id(params[:id]) if params[:id]
    gon.subscription_id = @subscription.id if @subscription.present?
    gon.organization_id = @organization.id if @organization.present?
  end

  def subscription_params
    params.require(:subscription).permit!
  end

  def resolve_layout
    if action_name == "new" || action_name == "create"
      "devise"
    else
      "application"
    end
  end
end
