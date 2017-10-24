class DashboardController < ApplicationController
  before_action :set_range

  def show
    @current_activities = FeedItem.interactions.where(created_at: @current_start..@current_end)
    @previous_activities = FeedItem.interactions.where(created_at: @previous_start..@previous_end)


    @activity_hash = [
      { name: "Inbound Messages", data: Message.inbound.group_by_day(:created_at, format: '%b %d', range: @current_start..@current_end).count },
      { name:"Outbound Messages", data: MessageRequest.sent.group_by_day(:processed_at, format: '%b %d', range: @current_start..@current_end).count },
      { name: "Inbound Calls", data: CallLog.group_by_day(:created_at, format: '%b %d', range: @current_start..@current_end).count }
    ]

    @twilio_client = Twilio::REST::Client.new(current_user.organization.twilio_auth_id, ENV['TWILIO_COLIN_AUTH_TOKEN'])

    @current_usage_total = @twilio_client.usage.records.this_month.list.map(&:price).map(&:to_f).sum
    @last_usage_total = @twilio_client.usage.records.last_month.list.map(&:price).map(&:to_f).sum

    @current_stops = current_user.organization.stops.where(created_at: 1.month.ago..Time.now).count
    @last_stops = current_user.organization.stops.where(created_at: 2.months.ago..1.month.ago).count
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

  rescue
    @flash_twilio_error = true
  end

  def activity_chart
    render json: [
      { name: "Inbound Messages", data: Message.inbound.group_by_day(:created_at, format: "%b", range: @current_start..@current_end).count },
      { name:"Outbound Messages", data: MessageRequest.sent.group_by_day(:processed_at, format: "%b", range: @current_start..@current_end).count },
      { name: "Inbound Calls", data: CallLog.group_by_day(:created_at, format: "%b", range: @current_start..@current_end).count }
    ].to_json
  end

  def set_range
    frame = params[:frame] ||= 'month' # refactor this to be a user preference
    @current_start = 1.send("#{frame}").ago
    @current_end = Time.now
    @previous_start = 1.send("#{params[:frame]}").ago.send("beginning_of_#{frame}")
    @previous_end = 1.send("#{params[:frame]}").ago.send("end_of_#{frame}")
  end
end
