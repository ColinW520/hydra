class Admin::DashboardController < Admin::BaseController
  def show
    range_start = params[:range_start] ||= 1.month.ago
    range_end = params[:range_start] ||= Time.now

    @activity_hash = {
      inbound_messages: Message.inbound.group_by_day(:created_at, range: range_start..range_end).count,
      outbound_messages: MessageRequest.sent.group_by_day(:processed_at, range: range_start..range_end).count,
      call_logs: CallLog.group_by_day(:created_at, range: range_start..range_end).count
    }
  end
end
