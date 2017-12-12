class Imports::ImportStartingWorker
  include Sidekiq::Worker
  sidekiq_options queue: :imports

  def perform(import_id)
    default_options = {
      force_utf8: true,
      invalid_byte_sequence: '',
      chunk_size: 100,
      downcase_header: true,
      headers_in_file: true,
      strip_whitespace: true,
      remove_empty_values: false, # opposite of the default here, we do want to know if any required key has a null value
      remove_zero_values: false, # opposite of the default here, we do want values even if they have a numeric value == 0 (zero)
      convert_values_to_numeric: false, # converts strings containing Integers or Floats to the appropriate class, also accepts either {:except => [:key1,:key2]} or {:only => :key3}
      force_simple_split: true,
      strip_chars_from_headers: /[\-"]/
    }

    @the_import = Import.find import_id
    return if @the_import.is_enqueued?
    @the_import.update_attributes(is_enqueued: true, status: 'processing')


    open(@the_import.datafile.url, "r:utf-8") do |file|
      SmarterCSV.process(file, default_options).each do |chunk|
        chunk.each do |row|
          puts row
          # result = ImportResult.create(import_id: @the_import.id, row_data: row.with_indifferent_access, status: 'enqueued')
          # Imports::ImportContactRowWorker.perform_async(result.id) if Rails.env.production?
          # Imports::ImportContactRowWorker.new.perform(result.id) if Rails.env.development?
        end
      end
    end

    open(@the_import.datafile.url, "r:utf-8") do |file|
      SmarterCSV.process(file, default_options).each do |chunk|
        chunk.each do |row|
          result = ImportResult.create(import_id: @the_import.id, row_data: row.with_indifferent_access, status: 'enqueued')
          Imports::ImportContactRowWorker.perform_async(result.id) if Rails.env.production?
          Imports::ImportContactRowWorker.new.perform(result.id) if Rails.env.development?
        end
      end
    end

    @the_import.rows_count = file.readlines.count
    @the_import.is_enqueued = false
    @the_import.status = 'succeeded'
    @the_import.save!
  rescue => error
    @the_import.update_attributes(status: 'failed', message: error.message, is_enqueued: false)
  end
end
