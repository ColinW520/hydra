class EmployeesController < ApplicationController
  def index
    @employees = Employee.accessible_by(current_ability)
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
