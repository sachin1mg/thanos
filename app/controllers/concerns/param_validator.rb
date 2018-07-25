module Concerns::ParamValidator
  extend ::ActiveSupport::Concern

  #
  # Overiding rails_param param! method to handle type error softly
  #
  def param!(name, type, options = {}, &block)
    begin
      super
    rescue TypeError
      raise ::RailsParam::Param::InvalidParameterError, "Invalid param #{name}"
    end
  end
end
