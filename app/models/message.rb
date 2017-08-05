class Message < ApplicationRecord
  belongs_to :contact
  belongs_to :message_request
  belongs_to :line
  belongs_to :organization
  scope :inbound, -> { where(direction: 'inbound') }
  scope :outbound, -> { where(direction: 'outbound') }

  validates :sms_sid,
            presence: true,
            uniqueness: true

  phony_normalize :to, default_country_code: 'US'
  phony_normalize :from, default_country_code: 'US'

  def self.filter_by(params)
    params = params.with_indifferent_access
    messages_scope = Message.joins('LEFT JOIN contacts ON contacts.id = messages.contact_id')
    messages_scope = messages_scope.where(messages: { contact_id: params[:contact_id] }) if params[:contact_id]
    messages_scope = messages_scope.where(messages: { organization_id: params[:organization_id] }) if params[:organization_id].present?
    messages_scope = messages_scope.where('messages.body ILIKE ?', "%#{params[:term]}%") if params[:term].present?
    messages_scope = messages_scope.where(messages: { from: params[:from_number] }) if params[:from_number].present?
    messages_scope = messages_scope.where(messages: { to: params[:to_number] }) if params[:to_number].present?
    messages_scope = messages_scope.where(messages: { direction: params[:direction] }) if params[:direction].present?
    messages_scope = messages_scope.where(messages: { line_id: params[:line] }) if params[:line].present?
    messages_scope = messages_scope.where('contacts.first_name ILIKE ? OR contacts.last_name ILIKE ?', "%#{params[:name]}%", "%#{params[:name]}%") if params[:name].present?

    return messages_scope
  end

  def detail_table
    # this should be a _decorator_ or helper...
    "<table>
      <tbody>
        <tr>
          <td><b>From City:</b></td>
          <td>#{self.from_city}</td>
        </tr>
        <tr>
          <td><b>From Zip:</b></td>
          <td>#{self.from_zip}</td>
        </tr>
        <tr>
          <td><b>From State:</b></td>
          <td>#{self.from_state}</td>
        </tr>
        <tr>
          <td><b>From Country:</b></td>
          <td>#{self.from_country}</td>
        </tr>
        <tr>
          <td><b>Segments:</b></td>
          <td>#{self.num_segments}</td>
        </tr>
        <tr>
          <td><b>Attachments:</b></td>
          <td>#{self.num_media}</td>
        </tr>
      </tbody>
    </table>"
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
