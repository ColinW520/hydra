class DashboardController < ApplicationController
  def show
  end

  def list_growth
    render json: current_user.organization.contacts.group_by_day(:created_at, range: 1.month.ago..Time.now, format: "%b %d").count.to_json
  end

  def usage
    @twilio_client = Twilio::REST::Client.new(current_user.organization.twilio_auth_id, ENV['TWILIO_COLIN_AUTH_TOKEN'])

    @last_month_records = []
    @twilio_client.usage.records.last_month.list.each do |record|
      @last_month_records << { description: record.description, price: record.price, count: record.count } if record.count.to_f > 0.to_f
    end

    @this_month_records = []
    @twilio_client.usage.records.this_month.list.each do |record|
      @this_month_records << { description: record.description, price: record.price, count: record.count } if record.count.to_f > 0.to_f
    end
  end

  def messages
    render json: current_user.organization.messages.group(:direction).group_by_day(:created_at, range: 1.month.ago..Time.now, format: "%b %d").count.chart_json
  end

  def calls
    render json: CallLog.where(organization_id: current_user.organization_id).group_by_day(:created_at, range: 1.month.ago..Time.now, format: "%b %d").count.chart_json
  end
end
