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
    @contact = Contact.new(contact_params)
    @contact.mobile_phone = PhonyRails.normalize_number(contact_params[:mobile_phone], country_code: 'US')

    respond_to do |format|
      if @contact.save
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
