module AuthModule
  #
  # This class is responsible for all permission related operations.(Authorization/updating permissions)
  #
  # @author [rohitjangid]
  #
  class Permissions
    attr_accessor :user

    #
    # Initialize Method
    # @param user: nil [AuthModule::User]
    # @param controller: '' [String] Path of the controller
    # @param action: '' [String] Method of the controller
    #
    def initialize(user: nil, controller: '', action: '')
      self.user = user
      @specific_path = controller + '#' + action
      @all_path = controller + '#*'
    end

    #
    # Raise error if given path is not authorized by the user
    #
    def authorize!
      # raise Unauthorized.new('No Permission') unless authorize
      return true
    end

    #
    # Check if given path is authorized to access by the user
    #
    # @return [Boolean] Returns true if authorized
    def authorize
      if is_open_call?
        return true
      elsif user.present?
        if is_login_call?
          return true
        elsif has_required_role?
          return true
        end
      end
      return false
    end

    #
    # Sync all the permissions with the resources yaml file
    #
    def refresh
      labels = roles_resources.keys
      current_permissions = push_permissions(labels)
      if current_permissions.present?
        Permission.where.not(id: current_permissions.map(&:id)).each{ |p| p.inactive! }
      end
    end

    private

    def push_permissions(labels)
      Permission.where(label: labels).update_all(status: :active)
      old_permissions = Permission.where(label: labels)
      new_labels = labels - old_permissions.pluck(:label)
      new_permissions = []
      new_labels.each do |label|
        permission = Permission.create!(label: label)
        permission.active!
        new_permissions << permission
      end
      old_permissions + new_permissions
    end

    #
    # Check if user has the required role for accessing given controller action pair
    #
    # @return [Boolean] Returns true if has required role
    def has_required_role?
      resource_permissions = roles_resources.values.compact.reduce{|resources, res| resources.merge(res)}
      paths = resource_permissions.slice(*user_permissions).values.flatten.uniq
      paths.include?(@all_path) || paths.include?(@specific_path)
    end

    #
    # List of permissions user have
    #
    # @return [Array] Array of permissions
    def user_permissions
      @user_permissions ||= user.permissions_given.active.map(&:label)
    end

    #
    # Check if current call is open to all call
    #
    # @return [Boolean] Returns true if open call
    def is_open_call?
      open_resources.include?(@all_path) || open_resources.include?(@specific_path)
    end

    #
    # Check if current call requires user to login
    #
    # @return [Boolean] Returns true if login call
    def is_login_call?
      login_resources.include?(@all_path) || login_resources.include?(@specific_path)
    end

    #
    # All open permissions resources
    #
    # @return [Array] Array of open resources
    def open_resources
      resources['open permission'] || []
    end

    #
    # All login permissions resources
    #
    # @return [Array] Array of login resources
    def login_resources
      resources['login permission'] || []
    end

    #
    # All roles resources
    #
    # @return [Hash] All roles resources
    def roles_resources
      resources['roles permission'] || {}
    end

    #
    # All the resources
    #
    # @return [Hash]
    def resources
      @resources ||= (Rails.cache.read(AuthModule::Resources::CACHE_KEY) || AuthModule::Resources.rebuild_cache)
    end
  end
end
