#
# This module enable searching on resources
#
# @author [rohitjangid]
module Searchable
  extend ActiveSupport::Concern
  module ClassMethods
    #
    # Provide skeleton of search in active records
    # @param query [String] Query String
    #
    # @return [ActiveRecord] Scope with search query
    def search(query)
      self
    end
  end
end
