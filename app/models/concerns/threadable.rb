#
# This module enable current user related methods on models
#
# @author [rohitjangid]
module Threadable
  extend ActiveSupport::Concern
  module ClassMethods
    #
    # Returns the instance user set in current thread
    #
    def current_user
      Thread.current[:user]
    end

    #
    # Returns the instance lgp set in current thread
    #
    def current_lgp
      Thread.current[:lgp]
    end
  end
end
