require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# # Load application ENV vars and merge with existing ENV vars. Loaded here so can use values in initializers.
# ENV.update YAML.load_file('config/application.yml')[Rails.env] rescue {}

module Hydra
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.force_ssl = true

    config.autoload_paths << Rails.root.join('lib', 'inputs')

    # ActsAsTaggableOn.force_binary_collation = true
    ActsAsTaggableOn.remove_unused_tags = true
    ActsAsTaggableOn.force_lowercase = true

    config.active_job.queue_adapter = :sidekiq

    config.paperclip_defaults = {
      storage: :s3,
      s3_region: ENV['AWS_REGION'],
      s3_credentials: {
        bucket: ENV['S3_BUCKET_NAME'],
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      }
    }

    config.action_mailer.default_url_options = { :host => Rails.env.development? ? "hydra.dev" : "aptexx-hydra.herokuapp.com" }
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.perform_deliveries = true
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.smtp_settings = {
      :user_name => ENV['SENDGRID_USERNAME'],
      :password => ENV['SENDGRID_PASSWORD'],
      :domain => 'aptexx-hydra.herokuapp.com',
      :address => 'smtp.sendgrid.net',
      :port => 587,
      :authentication => :plain,
      :enable_starttls_auto => true
    }
  end
end
