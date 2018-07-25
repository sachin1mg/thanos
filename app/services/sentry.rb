#
# This class acts as a wrapper on Raven Gem
#
# @author [rohitjangid]
class Sentry
  #
  # Send Error to Sentry
  # @param msg [String] Message
  # @param extra = {} [Hash] Extra Info
  #
  def self.error(msg, extra = {})
    self.capture(msg, level: :error, extra: extra)
  end

  #
  # Send info to Sentry
  # @param msg [String] Message
  # @param extra = {} [Hash] Extra Info
  #
  def self.info(msg, extra = {})
    self.capture(msg, level: :info, extra: extra)
  end

  #
  # Send Event to Sentry
  # @param msg [String] Message
  # @param level: 'info' [String] Level
  # @param extra: {} [Hash] Extra Info
  #
  def self.capture(msg, level: :info, extra: {})
    Logging.log(level, msg, extra)
    Raven.capture_message(msg,
                          level: level,
                          extra: extra,
                          user: user
                          )
  end

  #
  # Returns user hash for sentry
  #
  # @return [Hash] User info hash
  def self.user
    user = Thread.current[:user]
    return {} unless user.present?
    user.to_h
  end
end
