class Admin::PlansController < Admin::BaseController
  before_action :find_plan, except: [:index, :new, :create]

  def index
    plans_scope = Plan.all

    smart_listing_create :plans,
                        plans_scope,
                        partial: "admin/plans/listing",
                        default_sort: { created_at: "desc" }
  end

  def show

  end

  def edit

  end

  def update
    respond_to do |format|
      if @plan.update(plan_params)
        format.html {
          flash[:sucess] = 'Plan has been updated!'
          redirect_to plans_path
        }
        format.json { head :no_content }
        format.js { flash[:success] = 'Plan has been updated.' }
      else
        format.json { render json: @plan.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  private

  def find_plan
    @plan = Plan.find params[:id]
  end

  def plan_params
    params.require(:plan).permit!
  end
end
