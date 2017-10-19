class Admin::DashboardController < Admin::BaseController
  def show
    range_start = params[:range_start] ||= 1.month.ago
    range_end = params[:range_start] ||= Time.now

    @activity_hash = [
      { name: "Inbound Messages", data: Message.inbound.group_by_day(:created_at, range: range_start..range_end).count },
      { name:"Outbound Messages", data: MessageRequest.sent.group_by_day(:processed_at, range: range_start..range_end).count },
      { name: "Inbound Calls", data: CallLog.group_by_day(:created_at, range: range_start..range_end).count }
    ]
  end
end
