require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module VanillaApplication
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Set migration version to number
    config.active_record.timestamped_migrations = false

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'New Delhi'

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.autoload_paths << Rails.root.join('config/routes')

    # Removing - Rack::ConditionalGet: Supports the stale? feature in Rails controllers.
    config.middleware.delete Rack::ConditionalGet

    # Removing - Automatically set an ETag on all string responses
    config.middleware.delete Rack::ETag

    #Removing - Uses a front-end server's file serving support from your Rails application
    config.middleware.delete Rack::Sendfile
  end
end
