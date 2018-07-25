#
# Template class for yourls connections
#
# @author [rohitjangid]
class HttpPersistentConnection
  #
  # Initialize the connection
  #
  def initialize(max_age: 15 * 60)
    @max_age = max_age # 15 Minutes default
    reset
  end

  #
  # Returns the connection object
  #
  # @return [Net::HTTP::Persistent]
  def connection
    reset if age > @max_age
    @connection
  end

  #
  # Reset the connection
  #
  def reset
    @connection = Net::HTTP::Persistent.new
    @created_at = Time.zone.now
  end

  #
  # Return the age of current connection
  #
  # @return [Integer] Age
  def age
    (Time.zone.now - @created_at).to_i
  end
end