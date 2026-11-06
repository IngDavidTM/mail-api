require_relative 'boot'

require 'rails'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MailApi
  class Application < Rails::Application
    config.load_defaults 8.1
    config.api_only = true

    # Only the portfolio may call the API from a browser
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins 'https://david-tamayo.netlify.app'
        resource '/send_email',
                 headers: %w[Content-Type],
                 methods: %i[post options],
                 max_age: 7200
      end
    end

    config.middleware.use Rack::Attack

    # SMTP for development and production; tests use :test delivery
    unless Rails.env.test?
      config.action_mailer.delivery_method = :smtp
      config.action_mailer.smtp_settings = {
        address: ENV.fetch('SMTP_ADDRESS', 'smtp.gmail.com'),
        port: ENV.fetch('SMTP_PORT', 587).to_i,
        domain: ENV.fetch('SMTP_DOMAIN', 'gmail.com'),
        user_name: ENV['SMTP_USERNAME'] || ENV['EMAIL_USER_NAME'],
        password: ENV['SMTP_PASSWORD'] || ENV['EMAIL_PASSWORD'],
        authentication: ENV.fetch('SMTP_AUTHENTICATION', 'plain'),
        enable_starttls_auto: ENV.fetch('SMTP_ENABLE_STARTTLS_AUTO', 'true') != 'false'
      }
    end
  end
end
