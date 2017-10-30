# manage when this is run here: https://scheduler.heroku.com/dashboard
class Imports::ImportContactRowWorker
  include Sidekiq::Worker

  def perform
    Import.where(notified_at: nil).where('imports.import_results_count > 0').each do |import|
      if import.import_results.complete.count == import.import_results_count
        # notify
      end
    end
  end
end
