require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Dentsply
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # User-added
    config.time_zone = 'Europe/Helsinki'
    config.i18n.default_locale = :fi

    # CORS
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins {
          "https://#{Rails.application.credentials.dig(ENV['RAILS_ENV'].to_sym, :access_control_allow_origin)}"
        }
        resource '*',
                 headers: :any,
                 methods: [:get, :post, :put, :patch, :delete, :options],
                 expose: %w(Access-Control-Expose-Headers Content-Disposition)
      end
    end

    config.require_master_key = true
  end
end
