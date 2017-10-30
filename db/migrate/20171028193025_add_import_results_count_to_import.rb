class AddImportResultsCountToImport < ActiveRecord::Migration[5.0]
  def change
    add_column :imports, :rows_count, :integer, default: 0
    add_column :imports, :import_results_count, :integer, default: 0
  end
end
