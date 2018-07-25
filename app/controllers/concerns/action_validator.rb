module Concerns::ActionValidator
  extend ::ActiveSupport::Concern

  included do
    before_action :valid_action?
  end

  private

  def valid_action?
    self.send("valid_#{action_name}?")
  end
end
