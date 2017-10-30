class ImportResult < ApplicationRecord
  belongs_to :import, counter_cache: true

  serialize :row_data, JSON

  def self.to_csv
    attributes = self.column_names

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |result|
        csv << attributes.map { |attr| result.send(attr) }
      end
    end
  end
end
