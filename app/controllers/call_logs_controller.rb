class CallLogsController < ApplicationController
  def index
    @line = Line.find params[:line_id] if params[:line_id].present?
    call_logs_scope = current_user.organization.call_logs.filter_by params

    respond_to do |format|
      format.html { smart_listing_create :call_logs, call_logs_scope, partial: 'call_logs/listing', default_sort: { created_at: 'DESC' }, page_sizes: [25, 50, 100, 150, 200] }
      format.js { smart_listing_create :call_logs, call_logs_scope, partial: 'call_logs/listing', default_sort: { created_at: 'DESC' }, page_sizes: [25, 50, 100, 150, 200] }
      format.csv { send_data call_logs_scope.to_csv, filename: "call_logs_as_of-#{Time.now}.csv" }
    end
  end
end
