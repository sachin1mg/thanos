module Concerns::Cacheable
  extend ::ActiveSupport::Concern

  module ClassMethods
    #
    # Set hooks for caching response
    # @param provider = Caches::Base [Caches::Base] Cache Provider
    # @param only: [] [Array/Symbol]
    # @param except: [] [Array/Symbol]
    # @param expire_in: 15.minutes [Seconds]
    #
    def cache_response(provider = Caches::Base, only: [], except: [], expire_in: 15.minutes)
      # Set action hook options
      hook_options = {}
      hook_options[:only] = only if only.present?
      hook_options[:except] = except if except.present?

      # Set cache options
      cache_options = {
        expire_in: expire_in
      }

      # Set before action to return response from cache
      before_action hook_options do
        cached_data = cached_response(provider)
        # Check cached response
        if cached_data.present?
          render json: cached_data
        end
      end

      # Set after action to set cache
      after_action hook_options do
        # Set cache response
        set_cache(provider, cache_options)
      end
    end
  end

  #
  # Set current response as cache
  #
  def set_cache(provider, options = {})
    provider.set(cache_key, response.body.to_json, options)
  end

  #
  # Returns the cached response
  #
  def cached_response(provider)
    return @cached_response if instance_variable_defined? :@cached_response
    data = provider.get(cache_key) rescue nil
    @cached_response ||= JSON.parse(data) if data.present?
  end

  #
  # Defines the cache key
  #
  # @return [String]
  def cache_key
    @cache_key ||= Digest::MD5.hexdigest request.fullpath
  end
end
