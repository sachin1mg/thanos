module Api::Public
  class BaseController < ::BaseController
    before_action :disable_fields

    #
    # Disable query params fields and include options
    #
    def disable_fields
      params[:fields] = nil
    end
  end
end
