# frozen_string_literal: true

require 'rack/attack'
require 'json'

# Limits are per instance (in-memory store). Keep Cloud Run max instances low
# so the totals stay bounded.
Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

send_email = ->(req) { req.path == '/send_email' && req.post? }

limit = ENV.fetch('MAIL_API_THROTTLE_LIMIT', 5).to_i
period = ENV.fetch('MAIL_API_THROTTLE_PERIOD', 60).to_i

# Short bursts from one address
Rack::Attack.throttle('send_email/ip', limit:, period:) do |req|
  req.ip if send_email.call(req)
end

# A whole day from one address
Rack::Attack.throttle('send_email/ip/day', limit: ENV.fetch('MAIL_API_DAILY_LIMIT', 20).to_i, period: 1.day) do |req|
  req.ip if send_email.call(req)
end

# Everyone together: caps a spread-out flood from many addresses
Rack::Attack.throttle('send_email/global', limit: ENV.fetch('MAIL_API_GLOBAL_HOURLY_LIMIT', 60).to_i, period: 1.hour) do |req|
  'all' if send_email.call(req)
end

Rack::Attack.throttled_responder = lambda do |req|
  match_data = req.env['rack.attack.match_data'] || {}
  retry_after = match_data[:period].to_i

  body = { error: 'Too many requests, please wait before trying again.' }.to_json

  [429, { 'Content-Type' => 'application/json', 'Retry-After' => retry_after.to_s }, [body]]
end
