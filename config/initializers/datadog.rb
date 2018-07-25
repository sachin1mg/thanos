Datadog.configure do |c|
  c.tracer enabled: Settings.DATADOG.ENABLE, debug: Settings.DATADOG.DEBUG, env: Rails.env
  c.use :rails, service_name: 'vanilla-application-dash'
  c.use :sidekiq, service_name: 'vanilla-application-sidekiq'
end
