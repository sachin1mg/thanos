module Concerns::ThreadUserable
  extend ::ActiveSupport::Concern

  included do
    before_action :set_current_user_in_current_thread
    after_action :unset_current_user_in_current_thread
  end

  private

  #
  # Set current user for access in current thread
  #
  def set_current_user_in_current_thread
    Thread.current[:user] = current_user
  end

  #
  # Unset current user in current thread
  #
  def unset_current_user_in_current_thread
    Thread.current[:user] = nil
  end
end
