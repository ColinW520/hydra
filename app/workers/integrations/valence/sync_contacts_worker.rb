class Integrations::Valence::SyncContactsWorker
  include Sidekiq::Worker
  sidekiq_options queue: :integrations

  def perform(integration_id)
    @integration = IntegrationPartner.find integration_id
    properties_link = "https://#{@integration.subdomain_scope}.valencepm.com/api/v1/properties?api_key=#{@integration.auth_key}"

    HTTParty.get(properties_link).to_a.each do |property|
      HTTParty.get("https://#{@integration.subdomain_scope}.valencepm.com/api/v1/properties/#{property.fetch('community_code')}/leases?api_key=#{@integration.auth_key}").each do |lease|
        lease.fetch("residents", []).each do |resident|
          next unless resident.fetch("phone", false)
          contact = Contact.where(organization_id: @integration.organization_id, mobile_phone: PhonyRails.normalize_number(resident.fetch("phone"),country_code: 'US')).first_or_initialize(
            first_name: resident.fetch("first_name"),
            last_name: resident.fetch("last_name"),
            email: resident.fetch("email"),
            title: "Resident",
            internal_identifier: resident.fetch("id"),
            address_city: lease.fetch("unit", {}).fetch("address", {}).fetch("city"),
            address_state: lease.fetch("unit", {}).fetch("address", {}).fetch("state"),
            integration_partner_id: @integration.id
          )

          contact.tag_list = "#{property.fetch('name')}, #{lease.fetch('status')}"

          begin
            contact.save!
          rescue ActiveRecord::RecordInvalid => error
            next
          end
        end
      end
    end

    @integration.touch(:last_synchronized_at)
  end
end
