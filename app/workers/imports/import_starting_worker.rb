class Imports::ImportStartingWorker
  include Sidekiq::Worker

  def perform(import_id)
    default_options = {
      chunk_size: 100,
      downcase_header: true,
      headers_in_file: true,
      strip_whitespace: true,
      remove_empty_values: false, # opposite of the default here, we do want to know if any required key has a null value
      remove_zero_values: false, # opposite of the default here, we do want values even if they have a numeric value == 0 (zero)
      convert_values_to_numeric: false # converts strings containing Integers or Floats to the appropriate class, also accepts either {:except => [:key1,:key2]} or {:only => :key3}
    }
    # this worker expects an import object, then it hands off to the right row processor
    # Do something
    the_import = Import.find import_id
    return if the_import.is_enqueued?
    the_import.update_attribute(:is_enqueued, true)

    open(the_import.datafile.url, 'r:utf-8') do |f|   # don't forget to specify the UTF-8 encoding!!
      SmarterCSV.process(f, default_options).each do |chunk|
        # check this first chunk row to make sure it has the requisite keys. don't enqueue row workers if keys aren't present.
        chunk.each do |row|
          Imports::ImportContactRowWorker.new.perform(row, the_import.id) if Rails.env.development?
          Imports::ImportContactRowWorker.perform_async(row, the_import.id) if Rails.env.production?
        end
      end
    end

    the_import.update_attribute(:is_enqueued, false)
  end
end
