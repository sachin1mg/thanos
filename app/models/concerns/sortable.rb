#
# This module enable sorting on resources
#
# @author [rohitjangid]
module Sortable
  extend ActiveSupport::Concern
  module ClassMethods

    #
    # Apply sorting on current scope
    # @param sort_params [Hash] Sorting to apply in order. Eg: { a: :asc, b: :desc }
    # @return [Scope] Sorted scope
    #
    def c_sort(sort_params)
      # return self.scoped unless sorts_class.present?
      sorts.apply(sort_params)
    end

    #
    # @return [Sorts::Base] Collection of sorts
    #
    def sorts
      sorts_class.new(self.scoped)
    end

    #
    # Returns Class of sort collection
    #
    def sorts_class
      "::Queries::CustomSorts::#{self}".safe_constantize || ::Queries::Sorts
    end
  end
end
