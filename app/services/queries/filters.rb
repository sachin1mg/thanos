module Queries
  #
  # This class provide base functionality for filters
  #
  # @author [rohitjangid]
  #
  class Filters
    FILTERS_PRIORITY = {}
    #
    # Initialize Method
    # @param scope [ActiveRecord] Model Scope
    #
    def initialize(scope)
      self.scope = scope
    end

    #
    # Apply given filters
    # @param filters [Hash] Hash of filters
    #
    # @return [ActiveRecord] Scope with filters
    def apply(filters)
      ordered_custom_filters = {}

      filters.each do |filter, value|
        # next unless value.present?
        if attribute_filter? filter
          # apply attribute filter
          apply_attribute_filter(filter, value)
        elsif custom_filter? filter
          # Collect and order custom filter
          order = priority_of(filter)
          ordered_custom_filters[order] ||= []
          ordered_custom_filters[order] << [filter, value]
        else
          # Raise invalid filter exception
          raise BadRequest.new("Invalid filter #{filter}")
        end
      end

      # Apply custom filters in order
      ordered_custom_filters.sort.each do |_, custom_filters|
        custom_filters.each { |filter, value| apply_custom_filter(filter, value) }
      end

      scope
    end

    private

    attr_accessor :scope

    #
    # Check if given filter is attribute filter
    # @param filter [String/Symbol] Filter
    #
    # @return [Boolean] Returns true if attribute filter
    def attribute_filter?(filter)
      scope.has_attribute? filter
    end

    #
    # Apply attribute filter on scope
    # @param filter [String/Symbol] Filter
    # @param value [String] Value
    #
    def apply_attribute_filter(filter, value)
      self.scope = scope.where(filter => value)
    end

    #
    # Check if given filter is custom filter
    # @param filter [String/Symbol] Filter
    #
    # @return [Boolean] Returns true if custom filter
    def custom_filter?(filter)
      self.respond_to? filter
    end

    #
    # Apply custom filter on scope
    # @param filter [String/Symbol] Filter
    # @param value [String] Value
    #
    def apply_custom_filter(filter, value)
      args = [value]
      self.scope = self.public_send(filter, *args)
    end

    #
    # Returns the priority of given filter
    # @param filter [String]
    #
    def priority_of(filter)
      self.class::FILTERS_PRIORITY[filter.to_sym] || 0
    end
  end
end
