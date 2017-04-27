class EmployeesController < ApplicationController
  before_filter :find_employee, except: [:index, :new, :create, :download]

  def index
    employees_scope = Employee.accessible_by(current_ability).includes(:tags)
    # employees_scope = employees_scope.where(organization_id: current_user.organization_id)

    employees_scope = employees_scope.name_like(params[:name]) if params[:name].present?
    employees_scope = employees_scope.title_like(params[:title]) if params[:title].present?
    employees_scope = employees_scope.tagged_with(params[:tags]) if params[:tags].present?

    respond_to do |format|
      format.html { smart_listing_create :employees, employees_scope, partial: 'employees/listing', default_sort: { first_name: :asc }, page_sizes: [25, 50, 100, 150, 200] }
      format.js { smart_listing_create :employees, employees_scope, partial: 'employees/listing', default_sort: { first_name: :asc }, page_sizes: [25, 50, 100, 150, 200] }
      format.csv { send_data employees_scope.to_csv, filename: "employees_as_of-#{Time.now}.csv" }
    end
  end

  def download
    respond_to do |format|
      format.csv { send_data Employee.where(organization_id: current_user.organization_id).to_csv, filename: "employees_as_of-#{Time.now}.csv" }
    end
  end

  def new
    @employee = Employee.new(organization_id: current_user.organization_id)
  end

  def create
    @employee = Employee.create(employee_params)

    respond_to do |format|
      if @employee.save
        format.json { head :no_content }
        format.js { flash[:success] = 'Employee has been created.' }
        format.html {
          flash[:success] = 'Employee has been created.'
          redirect_to employees_path
        }
      else
        format.json { render json: @employee.errors.full_messages, status: :unprocessable_entity }
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
        format.js { flash[:success] = 'Employee has been updated.' }
      else
        format.json { render json: @employee.errors.full_messages, status: :unprocessable_entity }
        format.js { render json: @employee.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @employee.destroy
    respond_to do |format|
      format.js { flash[:success] = 'Employee removed.' }
      format.html { redirect_to employees_path, notice: 'Employee removed. This will remove the employee from your list, but dont worry, all messaging history will be preserved.' }
      format.json { head :no_content }
    end
  end

  private

  def find_employee
    @employee = Employee.find(params[:id])
  end

  def employee_params
    params.require(:employee).permit!
  end
end
