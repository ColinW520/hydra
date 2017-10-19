class Admin::DashboardController < Admin::BaseController
  def show
    @activity_hash = [
      { name: "Inbound Messages", data: Message.inbound.group_by_day(:created_at, range: 1.month.ago.beginning_of_day..Time.now).count },
      { name:"Outbound Messages", data: MessageRequest.sent.group_by_day(:processed_at, range: 1.month.ago.beginning_of_day..Time.now).count },
      { name: "Inbound Calls", data: CallLog.group_by_day(:created_at, range: 1.month.ago.beginning_of_day..Time.now).count }
    ]
  end
end
