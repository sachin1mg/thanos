Raven.configure do |config|
  config.dsn = Settings.SENTRY.DSN
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
  config.environments = ['staging', 'production']
end

Raven.tags_context(Settings.SENTRY.TAGS.to_hash)
