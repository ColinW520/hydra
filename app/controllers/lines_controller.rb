class LinesController < ApplicationController
  before_filter :find_line, except: [:index, :new, :create, :download]

  def index
    lines_scope = current_user.organization.lines
    smart_listing_create :lines, lines_scope, partial: 'lines/listing', default_sort: { name: :asc }, page_sizes: [10, 20, 30]
  end

  def new
    twilio_client = Twilio::REST::Client.new(current_user.organization.twilio_auth_id, ENV['TWILIO_COLIN_AUTH_TOKEN'])
    @numbers = twilio_client.available_phone_numbers.get("US").local.list(area_code: current_user.organization.preferred_area_code, capabilities: { voice: true, sms: true })
    @line = Line.new(organization_id: current_user.organization_id)
  end

  def create
    @line = Line.create(line_params)

    respond_to do |format|
      if @line.save
        format.json { head :no_content }
        format.js { flash[:success] = 'Line has been created.' }
        format.html {
          flash[:success] = 'Line has been created. Enjoy!'
          redirect_to lines_path
        }
      else
        format.json { render json: @line.errors.full_messages, status: :unprocessable_entity }
        format.js { flash[:error] = 'There has been an error... Is your account setup on Twilio and fully funded?' }
        format.html {
          flash[:success] = 'There has been an error. The line was not purchased on your Twilio acount... Is your account setup on Twilio and fully funded?'
          redirect_to lines_path
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
      if @line.update(line_params)
        @line.update_on_twilio # triggering this here intentionally.
        format.html {
          flash[:sucess] = 'Line has been updated!'
          redirect_to lines_path
        }
        format.json { head :no_content }
        format.js { flash[:success] = 'Line has been updated.' }
      else
        format.json { render json: @line.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @line.release!(current_user.id)
    respond_to do |format|
      format.js { flash[:success] = 'Line released. It will remain in this list for historical purposes.' }
      format.html { redirect_to lines_path, success: 'Line released. It will remain in this list for historical purposes.' }
      format.json { head :no_content }
    end
  end

  private

  def find_line
    @line = Line.find(params[:id])
  end

  def line_params
    params.require(:line).permit!
  end
end
