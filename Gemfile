source "https://rubygems.org"

ruby "~> 3.4.0"

# Only the parts of Rails this API uses: routing/controllers and mail.
# No Active Record, Active Storage, Action Cable or Action Text.
gem "railties", "~> 8.1.0"
gem "actionpack", "~> 8.1.0"
gem "actionmailer", "~> 8.1.0"

gem "puma", ">= 6.6"
gem "rack-cors", ">= 2.0.2"
gem "rack-attack", ">= 6.7"

gem "sentry-ruby"
gem "sentry-rails"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[windows jruby]

group :development, :test do
  gem "bundler-audit", require: false
end
