module AuthModule
  #
  # This class is responsible to maintain the permission resources
  #
  # @author [rohitjangid]
  #
  class Resources
    RESOURCES_FILE = 'config/resources.yml' # YAML file containing all the permissions
    CACHE_KEY = 'resources_' + Rails.env # Caching key

    #
    # Update the permission resources in cache
    #
    # TODO: Need to add some automated validations for YAML file
    #
    def self.rebuild_cache
      resources = YAML.load_file(RESOURCES_FILE)
      Rails.cache.write(CACHE_KEY, resources)
      resources
    end
  end
end
