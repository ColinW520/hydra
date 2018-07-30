class Integrations::Valence::QueuingWorker
  include Sidekiq::Worker
  sidekiq_options queue: :integrations

  def perform
    IntegrationPartner.valence.active.pluck(:id).each do |integration_id|
      Integrations::Valence::SyncContactsWorker.perform_async(integration_id)
    end
  end
end
