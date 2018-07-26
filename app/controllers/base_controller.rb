class BaseController < ApplicationController
  # prepend_before_action :disable_includes
  prepend_before_action :prepare_params
  before_action :valid_pagination_params?


  def valid_pagination_params?
    param! :page, Integer, default: 1
    param! :per_page, Integer, default: Settings.CONSTANTS.PAGINATION.DEFAULT_PER_PAGE
  end

  #
  # Disable includes
  #
  def disable_includes
    params[:include] = nil
  end

  #
  # Preprocess params
  #
  def prepare_params
    param! :fields, String, default: '', transform: -> (param) { param.split(',').map(&:to_sym) }
    param! :include, String, default: '', transform: -> (param) { param.split(',').map(&:to_sym) }
    param! :query, String, blank: false, transform: -> (query) { query.strip }
  end

  #
  # Perform render operation with serializers
  # @param scope: ActiveRecord Scope
  # @param meta: {} [Hash] Meta data
  # @param query: params [Hash] Hash for performing filtering, sorting, pagination
  # @param pagination: true [Boolean] Flag to disable pagination
  # @param pagination_meta: true [Boolean] Flag to disable pagination meta
  # @param sorting: false [Boolean] Flag to enable sorting
  # @param after_serialize: nil [Proc] Block to process after serialization
  #
  def render_serializer(scope:, meta: {}, query: params, pagination: true, pagination_meta: true, sorting: true, after_serialize: nil)
    pre_processor = Rendor::PreProcessor.new(
        scope: scope,
        meta: meta,
        query: query,
        pagination: pagination,
        pagination_meta: pagination_meta,
        sorting: sorting,
        after_serialize: after_serialize
      )
    pre_processor.serialized
    api_render json: pre_processor.json, meta: pre_processor.meta
  end
end
