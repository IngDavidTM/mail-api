# frozen_string_literal: true

require 'rack/attack'
require 'json'

Rack::Attack.cache.store ||= ActiveSupport::Cache::MemoryStore.new

limit = ENV.fetch('MAIL_API_THROTTLE_LIMIT', 5).to_i
period = ENV.fetch('MAIL_API_THROTTLE_PERIOD', 60).to_i

Rack::Attack.throttle('send_email/ip', limit:, period:) do |req|
  req.ip if req.path == '/send_email' && req.post?
end

Rack::Attack.throttled_response = lambda do |env|
  match_data = env['rack.attack.match_data'] || {}
  retry_after = match_data[:period].to_i

  body = { error: 'Too many requests, please wait before trying again.' }.to_json

  [429, { 'Content-Type' => 'application/json', 'Retry-After' => retry_after.to_s }, [body]]
end
