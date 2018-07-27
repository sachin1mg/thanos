module Api::Public
  class BaseController < ::AuthController
    def current_vendor
      current_user.vendor
    end
  end
end
