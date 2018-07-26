module Rendor
  #
  # This class is responsible for various preprocessing before rendering
  #
  # @author [rohitjangid]
  #
  class PreProcessor
    META_TOTAL_PAGES_KEY = 'total_pages'
    META_TOTAL_COUNT_KEY = 'total_count'

    attr_accessor :scope, # Scope for processing
                  :meta, # Meta hash
                  :json, # Json of scope
                  :fields, # Fields to display
                  :include_fields, # Fields to include
                  :sort_by, # Sorting field of scope
                  :page, # Page number
                  :per_page, # Number of page
                  :after_serialize # Block to be execute after serialization

    #
    # Initialize Method
    # @param scope: Scope for processing
    # @param meta: {} [Hash] Meta hash
    # @param query: {} [Hash] Query hash for various processing
    # @param pagination: true [Boolean] Flag to disable pagination
    # @param pagination_meta: true [Boolean] Flag to disable pagination meta info
    # @param sorting: false [Boolean] Flag to enable sorting
    # @param after_serialize: nil [Proc] Block to process after serialization
    #
    def initialize(scope:, meta: {}, query: {}, pagination: true, pagination_meta: true, sorting: false, after_serialize: nil)
      self.scope = scope
      self.meta = meta
      self.fields = query[:fields]
      self.include_fields = query[:include]
      self.sort_by = query[:sort_by]
      @enable_sorting = sorting
      @enable_pagination = pagination
      @enable_pagination_meta = pagination_meta
      self.page = (query[:page] || 1).to_i # Default first page
      self.per_page = (query[:per_page] || Settings.CONSTANTS.PAGINATION.DEFAULT_PER_PAGE).to_i
      self.after_serialize = after_serialize
      self.json = nil
    end

    #
    # Perform pre processing for serialized response
    #
    def serialized
      return self if scope.nil?
      prepare_sort_by
      apply_sorting
      apply_pagination if @enable_pagination
      # apply_select
      serialized_json

      # Call hook
      self.json = after_serialize.call(self.json) if after_serialize.present?

      self
    end

    private

    #
    # Prepare sort_by for using in serialization
    #
    def prepare_sort_by
      return unless @enable_sorting
      return if sort_by.blank?
      self.sort_by =  case sort_by
                      when String
                        Queries::Sorts.parse(sort_by)
                      else
                        sort_by
                      end
    end

    #
    # Apply sorting on scope
    #
    def apply_sorting
      return unless @enable_sorting
      return if sort_by.blank?
      return if scope_is_object?
      self.scope = self.scope.c_sort(sort_by)
    end

    #
    # Apply pagination on scope
    #
    def apply_pagination
      return unless @enable_pagination
      return if scope_is_object? && !self.scope.is_a?(Array)

      if self.scope.is_a? Array
        total_count = self.scope.count
        total_pages = (self.scope.count / per_page.to_f).ceil
        start_index = (page - 1) * per_page
        end_index = per_page > total_count ? total_count : per_page
        if start_index <= total_count
          self.scope = self.scope[start_index, end_index]
        else
          raise InvalidFilterException.new('invalid pagination')
        end
      else
        self.scope = self.scope.page(page).per(per_page)
        if @enable_pagination_meta
          total_pages = self.scope.total_pages
          total_count = self.scope.total_count
        end
      end

      if @enable_pagination_meta
        meta.merge!(
          META_TOTAL_PAGES_KEY => total_pages,
          META_TOTAL_COUNT_KEY => total_count
        )
      end
    end

    #
    # Check if current scope is an object
    #
    # @return [Boolean] Returns true if scope is object
    def scope_is_object?
      not (scope.is_a?(Class) || scope.is_a?(ActiveRecord::Relation))
    end

    #
    # Apply select on scope for optimization of query
    #
    def apply_select
      return if scope_is_object?
      return if fields.include? :* # Select all if all fields are asked
      select_fields = fields.select { |f| model.column_names.include? f.to_s }
      select_fields = serializer.default_attributes.select { |f| model.column_names.include? f.to_s } if select_fields.blank?
      select_fields = model.default_attributes if select_fields.blank?
      self.scope = scope.select(select_fields)
    end

    #
    # Return serialized json for current scope
    #
    # @return [Hash] Serialized JSON
    def serialized_json
      options = {}
      options[:fields] = fields if fields.present?
      options[:include] = include_fields if include_fields.present?
      self.json = ActiveModelSerializers::SerializableResource.new(scope, options).as_json
    end

    #
    # Return serialzer for current scope
    #
    def serializer
      "#{model}Serializer".constantize
    end

    #
    # Return model of current scope
    #
    def model
      case scope
      when ApplicationRecord
        scope.class
      when ActiveRecord::Relation
        scope.model
      else
        scope
      end
    end
  end
end
