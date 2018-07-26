module Api::Public
  class BaseController < ::AuthController
    def current_vendor
      Vendor.last
    end
  end
end
