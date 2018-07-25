VanillaApplication::Application.configure do
  config.lograge.enabled = true
  config.lograge.formatter = Lograge::Formatters::Logstash.new
  config.lograge.custom_options = lambda do |event|
    data = {
        app_name: Rails.application.class.parent_name.underscore
    }

    data[:params] = event.payload[:params].reject { |k| %w(controller action).include?(k) }

    request = event.payload[:request]
    data[:request_headers] = {}.tap do |headers|
      request.headers.each do |key, value|
        next if key.downcase.match(/authorization/i)
        headers[key] = value if key.downcase.match?(/\Ahttp/i)
      end
    end

    response = event.payload[:response]
    if response.present?
      data[:response] = if request.format.json?
                          JSON.parse(response.body)
                        end
      data[:response_headers] = response.headers
    end

    exception_object = event.payload[:exception_object]
    data[:error_backtrace] = exception_object.backtrace if exception_object

    data
  end
end
