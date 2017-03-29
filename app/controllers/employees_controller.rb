class EmployeesController < ApplicationController
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  before_filter :find_employee, except: [:index, :new, :create]

  def index
    employees_scope = Employee.accessible_by(current_ability)
    employees_scope = employees_scope.where(organization_id: params[:organization_id])
    
    smart_listing_create :employees,
                         employees_scope,
                         partial: "employees/listing",
                         default_sort: { created_at: "desc" }
  end

  def new
    @employee = Employee.new()
  end

  def create
    @employee = Employee.create(employee_params)

    respond_to do |format|
      if @employee.save
        format.json { head :no_content }
        format.js { flash.now[:success] = 'Employee has been created.' }
      else
        format.json { render json: @solution.errors.full_messages, status: :unprocessable_entity }
      end

    end
  end

  def show

  end

  def edit

  end

  def update
    respond_to do |format|
      if @employee.update(employee_params)
        format.html {
          flash[:sucess] = 'Employee has been updated!'
          redirect_to employees_path
        }
        format.json { head :no_content }
        format.js { flash.now[:success] = 'Employee has been updated.' }
      else
        format.json { render json: @employee.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @employee.soft_delete!
    sign_out_and_redirect(@employee)
    respond_to do |format|
      format.js { flash.now[:success] = 'Employee removed.' }
      format.html { redirect_to employees_path, notice: 'Employee removed.' }
      format.json { head :no_content }
    end
  end

  def restore

  end

  private

  def find_employee
    @employee = Employee.find(params[:id])
  end

  def employee_params
    params.require(:employee).permit!
  end
end
