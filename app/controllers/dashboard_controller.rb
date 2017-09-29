class DashboardController < ApplicationController
  def show
  end

  def list_growth
    render json: current_user.organization.contacts.group_by_day(:created_at, range: 2.week.ago..Time.now, format: "%b %d").count.to_json
  end

  def usage
    @twilio_client = Twilio::REST::Client.new(current_user.organization.twilio_auth_id, ENV['TWILIO_COLIN_AUTH_TOKEN'])

    @records = []
    case params[:time_frame]
      when 'last_month'
        @twilio_client.usage.records.last_month.list.each do |record|
          @records << { description: record.description, price: record.price, count: record.count } if record.count.to_f > 0.to_f
        end
      else
        @twilio_client.usage.records.this_month.list.each do |record|
          @records << { description: record.description, price: record.price, count: record.count } if record.count.to_f > 0.to_f
        end
    end
  end

  def messages
    render json: current_user.organization.messages.group(:direction).group_by_day(:created_at, range: 2.week.ago..Time.now, time_zone: 'America/Chicago').count.chart_json
  end

  def calls
    render json: current_user.organization.call_logs.joins(:line).group('lines.name').group_by_day('call_logs.created_at', range: 2.week.ago..Time.now, time_zone: 'America/Chicago').count.chart_json
  end
end
