require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'twitter'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)
TWITTER_CONFIG = YAML.load(File.read(File.expand_path('twitter.yml', __FILE__)))

module SonicChimes
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    twitter_client = Twitter::REST::Client.new do |config|
      config.consumer_key        = TWITTER_CONFIG['consumer_key']
      config.consumer_secret     = TWITTER_CONFIG['consumer_secret']
      config.access_token        = TWITTER_CONFIG['access_token']
      config.access_token_secret = TWITTER_CONFIG['access_token_secret']
    end
  end
end
