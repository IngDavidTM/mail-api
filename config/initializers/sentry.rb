if ENV["SENTRY_DSN"]
  Sentry.init do |config|
    config.dsn = ENV["SENTRY_DSN"]
    config.breadcrumbs_logger = [:active_support_logger, :http_logger]

    sample_rate = ENV.fetch('SENTRY_TRACES_SAMPLE_RATE', '0.1').to_f
    config.traces_sample_rate = sample_rate.clamp(0.0, 1.0)
  end
end
