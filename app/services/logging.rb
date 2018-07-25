#
# This class provide method for logging
#
# @author [rohitjangid]
class Logging
  LEVELS = [:debug, :info, :warn, :error, :fatal]

  #
  # Log info level
  # @message ['String'] Message
  # @extra = {} [Hash] Extra information
  #
  def self.info(message, extra = {})
    self.log(:info, message, extra)
  end

  #
  # Log error level
  # @message ['String'] Message
  # @extra = {} [Hash] Extra information
  #
  def self.error(message, extra = {})
    self.log(:error, message, extra)
  end

  #
  # Log given message
  # @level_name [Symbol/String] Level of log
  # @message ['String'] Message
  # @extra = {} [Hash] Extra information
  #
  def self.log(level_name, message, extra = {})
    Rails.logger.log(level_of(level_name), formatted_log(message, extra))
  end

  #
  # Format log to logstash format
  # @message ['String'] Message
  # @extra = {} [Hash] Extra information
  #
  def self.formatted_log(message, extra = {})
    {
      message: message,
      '@timestamp': Time.now.utc
    }.merge(extra).to_json
  end

  #
  # Return level of given level name
  # @level_name [Symbol/String] Level of log
  #
  def self.level_of(level_name)
    index = LEVELS.index(level_name.to_sym)
    raise ArgumentError.new("Invalid log level #{level_name}") if index.nil?
    index
  end
end
