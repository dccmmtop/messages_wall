require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MessagesWall
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.paths.add File.join('app', 'api'), glob: File.join('**', '*.rb')
    config.time_zone = 'Beijing'
    config.active_record.default_timezone = :local
    config.autoload_paths += Dir[Rails.root.join('app')]
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '\_', :headers => :any, :methods => [:get, :post, :options]
      end
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
