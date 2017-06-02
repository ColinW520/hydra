class Message < ApplicationRecord
  belongs_to :contact

  def self.filter_by(params)
    messages_scope = Message.joins(:contact)

    messages_scope = messages_scope.where('messages.body ILIKE ?', "%#{params[:term]}%") if params[:term].present?
    messages_scope = messages_scope.where(messages: { from: params[:from_number] }) if params[:from_number].present?
    messages_scope = messages_scope.where(messages: { to: params[:to_number] }) if params[:to_number].present?
    messages_scope = messages_scope.where(messages: { direction: params[:direction] }) if params[:direction].present?
    messages_scope = messages_scope.where('contacts.first_name ILIKE ? OR contacts.last_name ILIKE ?', "%#{params[:name]}%", "%#{params[:name]}%") if params[:name].present?

    return messages_scope
  end

  def self.to_csv
    attributes = self.column_names

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |contact|
        csv << attributes.map { |attr| contact.send(attr) }
      end
    end
  end
end
