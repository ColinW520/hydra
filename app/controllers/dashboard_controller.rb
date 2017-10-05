class DashboardController < ApplicationController
  def show
  end

  def list_growth
    render json: current_user.organization.contacts.group_by_day(:created_at, range: 2.week.ago..Time.now, format: "%b %d").count.to_json
  end

  def usage
    @twilio_client = Twilio::REST::Client.new(current_user.organization.twilio_auth_id, ENV['TWILIO_COLIN_AUTH_TOKEN'])

    @records = {}
    @twilio_client.usage.records.last_month.list.each do |record|
      @records[record.description] = { last_month_count: record.usage.to_i, last_month_price: record.price }
    end

    @twilio_client.usage.records.this_month.list.each do |record|
      @records[record.description][:this_month_count] = record.usage.to_i
      @records[record.description][:this_month_price] = record.price
    end

    @the_records = []
    @records.each do |record|
      next unless record[1][:this_month_count] > 0 || record[1][:last_month_count] > 0
      @the_records << record
    end
  end

  def messages
    render json: current_user.organization.messages.group(:direction).group_by_day(:created_at, range: 1.weeks.ago..Time.now, time_zone: 'America/Chicago', format: "%d-%b").count.chart_json
  end

  def calls
    render json: current_user.organization.call_logs.group_by_day(:created_at, range: 1.week.ago..Time.now, time_zone: 'America/Chicago', format: "%d-%b").count.chart_json
  end
end
