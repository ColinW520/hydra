class CallLogsController < ApplicationController
  def index
    call_logs_scope = CallLog.filter_by(params.merge(organization_id: current_user.organization_id))

    respond_to do |format|
      format.html { smart_listing_create :messages, messages_scope, partial: 'messages/listing', sort_attributes: sort_columns, default_sort: { date: 'DESC' }, page_sizes: [25, 50, 100, 150, 200] }
      format.js { smart_listing_create :messages, messages_scope, partial: 'messages/listing', sort_attributes: sort_columns, default_sort: { date: 'DESC' }, page_sizes: [25, 50, 100, 150, 200] }
      format.csv { send_data messages_scope.to_csv, filename: "messages_as_of-#{Time.now}.csv" }
    end
  end
end
