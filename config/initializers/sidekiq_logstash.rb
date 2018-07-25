# Enable logstash logs
Sidekiq::Logstash.setup

Sidekiq::Logstash.configure do |config|
  config.custom_options = lambda do |payload|
    payload[:app_name] = Rails.application.class.parent_name.underscore
  end
end
