module Api::Public::V1
  class MaterialRequestsController < ::Api::Public::AuthController
    skip_before_action :valid_action?, only: :show

    # GET /material_requests
    def index
      resources = material_requests.filter(index_filters)
      render_serializer scope: resources
    end

    # GET /material_requests/1
    def show
      render_serializer scope: material_request
    end

    private

    def material_requests
      current_vendor.material_requests
    end

    def material_request
      @material_request ||= material_requests.find(params[:id])
    end

    def index_filters
      param! :id, Integer, blank: false
      param! :status, String, blank: false
      param! :created_from, Date, blank: false
      param! :created_to, Date, blank: false

      params.permit(:id, :status, :created_from, :created_to)
    end

    #####################
    #### VALIDATIONS ####
    #####################

    def valid_index?
      param! :sort_by, String, default: 'id:asc'
    end
  end
end
