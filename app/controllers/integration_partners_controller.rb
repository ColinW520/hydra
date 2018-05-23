class IntegrationPartnersController < ApplicationController
  before_action :find_integration_partner, except: [:index, :new, :create, :download]

  def index
    integration_partners_scope = @current_organization.integration_partners
    smart_listing_create(
      :integration_partners,
      integration_partners_scope,
      partial: 'integration_partners/listing',
      default_sort: { name: :asc },
      page_sizes: [10, 20, 30]
    )
  end

  def new
    @integration_partner = IntegrationPartner.new
  end

  def create
    @integration_partner = IntegrationPartner.create(integration_partner_params)

    respond_to do |format|
      if @integration_partner.save
        store_feed_item(@integration_partner, "#{current_user.try(:first_name).try(:titleize)} added a new integration_partner: #{@integration_partner.name}.")
        format.json { head :no_content }
        format.js { flash[:success] = 'Integration Partner added.' }
        format.html {
          flash[:success] = 'Integration Partner added.'
          redirect_to integration_partners_path
        }
      else
        format.json { render json: @integration_partner.errors.full_messages, status: :unprocessable_entity }
        format.js { flash[:error] = 'There has been an error.' }
        format.html {
          flash[:success] = 'There has been an error.'
          redirect_to integration_partners_path
        }
      end

    end
  end

  def show

  end

  def edit

  end

  def update
    respond_to do |format|
      if @integration_partner.update(integration_partner_params)
        store_feed_item(@integration_partner, "#{current_user.try(:first_name).try(:titleize)} updated integration settings for the #{@integration_partner.name} integration.")
        format.html {
          flash[:sucess] = 'Integration Partner updated!'
          redirect_to integration_partners_path
        }
        format.json { head :no_content }
        format.js { flash[:success] = 'Integration Partner updated.' }
      else
        format.json { render json: @integration_partner.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  private

  def find_integration_partner
    @integration_partner = IntegrationPartner.find(params[:id])
  end

  def integration_partner_params
    params.require(:integration_partner).permit!
  end
end
