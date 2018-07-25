module Queries
  #
  # This class provide base functionality for sorting
  #
  # @author [rohitjangid]
  class Sorts
    #
    # @param scope [ActiveRecord] Model scope
    #
    def initialize(scope)
      self.scope = scope
    end

    #
    # Parse params in format for applying sorting
    # @param params [String] Params String
    #
    # @return [Hash] Hash of sorting
    def self.parse(params)
      {}.tap do |sort_by|
        params.to_s.split(',').each do |p|
          next if p.blank?
          sort = p.split(':')
          key = sort[0]
          order = sort[1] || :asc
          sort_by[key] = order
        end
      end
    end

    #
    # Apply given sorts
    # @param sorts[Hash]
    #
    def apply(sorts)
      sorts.each do |sort, order|
        order ||= :asc
        if attribute_sort? sort
          # apply attribute sort
          apply_attribute_sort(sort, order)
        elsif custom_sort? sort
          # apply custom sort
          apply_custom_sort(sort, order)
        else
          # Raise invalid sort exception
          raise BadRequest.new("Invalid sort #{sort}")
        end
      end
      scope
    end

    private

    attr_accessor :scope

    #
    # Check if given sort is attribute sort
    # @param field [String/Symbol] field
    #
    # @return [Boolean] Returns true if attribute sort
    def attribute_sort?(field)
      scope.has_attribute? field
    end

    #
    # Apply attribute sort on scope
    # @param field [String/Symbol] sort
    # @param order [String/Symbol] Value
    #
    def apply_attribute_sort(field, order)
      self.scope = scope.order(field => order)
    end

    #
    # Check if given sort is custom sort
    # @param sort_by [String/Symbol] sort_by
    #
    # @return [Boolean] Returns true if custom sort
    def custom_sort?(sort_by)
      self.respond_to? sort_by
    end

    #
    # Apply custom sort on scope
    # @param sort_by [String/Symbol] sort_by
    # @param order [String/Symbol] Value
    #
    def apply_custom_sort(sort_by, order)
      self.scope = self.public_send(sort_by, order)
    end
  end
end
