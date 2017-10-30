class ImportResultsController < ApplicationController
  before_action :find_import

  def index
    results_scope = ImportResult.all
    smart_listing_create :import_results, results_scope, partial: "import_results/listing", default_sort: { created_at: "desc" }

    respond_to do |format|
      format.html {
        smart_listing_create :import_results, results_scope, partial: "import_results/listing", default_sort: { created_at: "desc" }
      }
      format.js {
        smart_listing_create :import_results, results_scope, partial: "import_results/listing", default_sort: { created_at: "desc" }
      }
      format.csv { send_data results_scope.to_csv, filename: "results_for_import_#{@import.id}.csv" }
    end

  end

  private

  def find_import
    @import = current_user.organization.imports.find params[:import_id]
  end
end
