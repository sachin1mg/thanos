class ValidationFailed < StandardError
  attr_accessor :message, :options

  def initialize(message, options = {})
    self.message = message
    self.options = options
    super(message)
  end

  def as_json
    { message: message }.merge(options)
  end
end
