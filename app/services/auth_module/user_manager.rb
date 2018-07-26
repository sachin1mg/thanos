module AuthModule
  #
  # This class is responsible for managing users from order creation flow
  #
  # @author [rohitjangid]
  #
  class UserManager
    attr_accessor :user

    #
    # Initialize Method
    # @param user [User instance]
    #
    def initialize(user)
      self.user = user
    end

    #
    # Find or create user
    # @param user_params: [Hash] Required
    # @return [ActiveRecord User] Created user
    #
    def self.create!(user_params:)
      raise BadRequest.new('Email is mandatory') unless user_params[:email].present?
      user = User.find_by(email: user_params[:email])
      user_params[:password] ||= user_params[:phone_number]
      user || User.create!(user_params)
    end

    def update(user_params)
      user.update_attributes!(user_params.except(:email))
    end
  end
end
