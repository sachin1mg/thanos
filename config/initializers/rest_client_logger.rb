class RestClientLogger
  LOGGER = Logger.new("#{Rails.root}/log/api.log")
  LOGGER.formatter = proc do |severity, datetime, progname, msg|
    "#{msg.to_json}\n" rescue "#{msg}\n"
  end

  def self.log(data)
    LOGGER.info(data)
  end
end
