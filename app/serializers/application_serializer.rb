class ApplicationSerializer < ActiveModel::Serializer
  def serializable_hash(*args)
    args[1] ||= {}
    if args[1][:fields]&.include?(:*)
      # Return all fields
      args[1][:fields] = (self.class.wildcard_attributes || self.class.default_attributes)
    else
      # Return demanded fields
      args[1][:fields] ||= self.class.default_attributes # Init fields with default value
    end

    args[1][:fields] = args[1][:fields].concat(args[0][:include] || []) # Include all included value to fields
    super
  end

  #
  # Default attributes for serializer
  #
  # @return [Array] Array of symbolize attributes
  def self.default_attributes
    not_implemented
  end

  #
  # wildcard attributes for serializer.
  # Returns nil for all serializer attributes
  #
  # @return [Array] Array of symbolize attributes
  def self.wildcard_attributes
  end
end
