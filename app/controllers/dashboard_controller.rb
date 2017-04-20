class DashboardController < ApplicationController
  def show
  end

  def list_growth
    render json: Employee.where(organization_id: current_user.organization).group_by_day(:created_at).count.to_json
  end
end
