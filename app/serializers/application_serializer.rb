class ApplicationSerializer < ActiveModel::Serializer
  def attributes(*args)
    args[0] ||= default_attributes
    super(*args)
  end

  private

  #
  # Default attributes for serializer
  #
  # @return [Array] Array of symbolize attributes
  def default_attributes
    not_implemented
  end
end
