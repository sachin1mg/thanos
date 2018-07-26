module Api::Public
  class AuthController < BaseController
    before_action :authenticate!

    private

    def authenticate!
      raise Unauthorized.new unless signed_in?
    end
  end
end