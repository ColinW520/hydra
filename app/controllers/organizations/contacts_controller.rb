class Organizations::ContactsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :find_organization

  layout 'signups'

  def success

  end

  def new
    @contact = Contact.new(organization_id: @organization.id)
  end

  def signup
    @contact = Contact.where(
      organization_id: @organization.id,
      mobile_phone: PhonyRails.normalize_number(contact_params[:mobile_phone], country_code: 'US')
    ).first_or_initialize

    @contact.first_name = contact_params[:first_name]
    @contact.last_name = contact_params[:last_name]
    @contact.address_city = contact_params[:address_city]
    @contact.address_state = contact_params[:address_state]
    @contact.is_active = contact_params[:is_active]

    respond_to do |format|
      if @contact.save
        SignupsMailer.new_signup(@contact.id).deliver_later
        format.html {
          redirect_to organization_success_path
        }
      else
        format.html {
          render 'new'
        }
        format.json { render json: @contact.errors.full_messages, status: :unprocessable_entity }
      end

    end
  end

  def show
  end

  def edit
  end

  private

  def find_organization
    @organization = Organization.friendly.find(params[:organization_id])
  end

  def contact_params
    params.require(:contact).permit!
  end
end
