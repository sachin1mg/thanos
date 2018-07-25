# Disable all logs
if Rails.env.staging? or Rails.env.production?
  ActiveSupport::Notifications.unsubscribe(ActiveModelSerializers::Logging::RENDER_EVENT)
end
