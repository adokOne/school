require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Core
  class Application < Rails::Application
    Dir[File.join(config.root, 'lib', 'core_ext', '*.rb')].each { |file| require file }
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.autoload_paths += Dir[Rails.root.join('app', 'models', '{**}')]
    config.autoload_paths += Dir["#{config.root}/app/models/**/","#{config.root}/lib", "#{config.root}/lib/**/"]
    config.assets.paths << config.root.join("app", "assets", "fonts")
    # config.i18n.default_locale = :de
    config.i18n.available_locales = [:en, :uk ]
    # config.i18n.available_locales = %w(en en-GB en-AU de zh-CN ru tr en-CA en-NZ en-IE en-SG en-IN es fr it th)
    config.i18n.default_locale = :uk
    config.i18n.fallbacks = true

    config.generators do |g|
      g.orm :active_record
    end
    require Rails.root.join("lib/custom_public_exceptions")
    config.exceptions_app = CustomPublicExceptions.new(Rails.public_path)

  end
end
