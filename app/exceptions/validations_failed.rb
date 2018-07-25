class ValidationsFailed < StandardError
  attr_accessor :errors
  delegate :present?, to: :errors

  def initialize(*args)
    self.errors = []
    super
  end

  def add(message, option = {})
    self.errors << ValidationFailed.new(message, option)
    self
  end

  def as_json
    self.errors.map(&:as_json)
  end
end
