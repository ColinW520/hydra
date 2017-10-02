class Admin::SubscriptionsController < Admin::BaseController
  before_action :find_subscription, except: [:index, :new, :create]

  def index
    subscriptions_scope = Subscription.includes(:plan).all

    smart_listing_create :subscriptions,
                        subscriptions_scope,
                        partial: "admin/subscriptions/listing",
                        default_sort: { created_at: "desc" }
  end

  def show

  end

  private

  def find_subscription
    @subscription = Subscription.find params[:id]
  end

  def subscription_params
    params.require(:subscription).permit!
  end
end
