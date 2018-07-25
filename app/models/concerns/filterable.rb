#
# This module enable filtering on resources
#
# @author [rohitjangid]
module Filterable
  extend ActiveSupport::Concern
  module ClassMethods

    #
    # Apply filter on current scope
    # @param filtering_params [Hash] Filters to apply
    #
    # @return [Scope] Filtered Scope
    def filter(filtering_params)
      return self.scoped unless filters_class.present?
      filters.apply(filtering_params)
    end

    #
    # Return instance of filter collection
    #
    # @return [Filters::Base] Collection of filters
    def filters
      filters_class&.new(self.scoped)
    end

    #
    # Returns Class of filter collection
    #
    def filters_class
      "::Queries::CustomFilters::#{self.to_s}".safe_constantize
    end
  end
end
