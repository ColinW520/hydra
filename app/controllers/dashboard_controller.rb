class DashboardController < ApplicationController
  def show
  end

  def list_growth
    render json: current_user.organization.messages.group_by_day(:created_at).count.to_json
  end

  def usage
  end

  def messages
    render json: current_user.organization.messages.group(:direction).group_by_day(:created_at).count.chart_json
  end

  def calls
    render json: current_user.organization.call_logs.joins(:line).group('lines.name').group_by_day(:created_at).count.chart_json
  end
end
