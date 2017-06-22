class ContactsController < ApplicationController
  before_filter :find_contact, except: [:index, :new, :create, :download]

  def index
    contacts_scope = Contact.filter_by(params)

    respond_to do |format|
      format.html {
        smart_listing_create :contacts, contacts_scope, partial: 'contacts/listing', default_sort: { first_name: :asc }, page_sizes: [25, 50, 100, 150, 200]
      }
      format.js { smart_listing_create :contacts, contacts_scope, partial: 'contacts/listing', default_sort: { first_name: :asc }, page_sizes: [25, 50, 100, 150, 200] }
      format.csv { send_data contacts_scope.to_csv, filename: "contacts_as_of-#{Time.now}.csv" }
    end
  end

  def new
    @contact = Contact.new(organization_id: current_user.organization_id)
  end

  def create
    @tags = params[:contact][:tag_list_for_form]
    @contact = Contact.create(contact_params.except(:tag_list_for_form))

    respond_to do |format|
      if @contact.save
        current_user.organization.tag(@contact, with: @tags, on: :tags) if @tags.present?
        format.json { head :no_content }
        format.js { flash[:success] = 'Contact has been created.' }
        format.html {
          flash[:success] = 'Contact has been created.'
          redirect_to contacts_path
        }
      else
        format.json { render json: @contact.errors.full_messages, status: :unprocessable_entity }
      end

    end
  end

  def show
  end

  def edit

  end

  def update
    @tags = params[:contact][:tag_list_for_form]
    current_user.organization.tag(@contact, with: @tags, on: :tags) if @tags.present?

    respond_to do |format|
      if @contact.update(contact_params.except(:tag_list_for_form))
        format.html {
          flash[:sucess] = 'Contact has been updated!'
          redirect_to contacts_path
        }
        format.json { head :no_content }
        format.js { flash[:success] = 'Contact has been updated.' }
      else
        format.json { render json: @contact.errors.full_messages, status: :unprocessable_entity }
        format.js { render json: @contact.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @contact.destroy
    respond_to do |format|
      format.js { flash[:success] = 'Contact removed.' }
      format.html { redirect_to contacts_path, notice: 'Contact removed. This will remove the contact from your list, but dont worry, all messaging history will be preserved.' }
      format.json { head :no_content }
    end
  end

  private

  def find_contact
    @contact = Contact.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit!
  end
end
