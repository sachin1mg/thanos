module Api::Public::V1
  class MaterialRequestsController < ::Api::Public::AuthController
    skip_before_action :valid_action?, only: [:show, :destroy]

    # GET /material_requests
    def index
      resources = material_requests.filter(index_filters)
      render_serializer scope: resources
    end

    # GET /material_requests/1
    def show
      render_serializer scope: material_request
    end

    def create
      material_request = material_requests.create!(material_request_create_params)
      render_serializer scope: material_request
    end

    def update
      material_request.update_attributes!(material_request_update_params)
      render_serializer scope: material_request
    end

    # DELETE /material_requests/1
    def destroy
      material_request.destroy!
      api_render json: {}
    end

    private

    def material_request_create_params
      params.require(:material_request).permit(:code, :type, :delivery_date, :metadata)
    end

    def material_request_update_params
      params.require(:material_request).permit(:delivery_date, :metadata)
    end

    def material_requests
      current_vendor.material_requests
    end

    def sales_order
      @sales_order ||= SalesOrder.find(params[:sales_order_id])
    end

    def material_request
      @material_request ||= material_requests.find(params[:id])
    end

    def index_filters
      param! :sales_order_id, String, blank: false
      param! :type, String, blank: false
      param! :delivery_date, Date, blank: false

      params.permit(:sales_order_id, :type, :delivery_date)
    end

    #####################
    #### VALIDATIONS ####
    #####################

    def valid_index?
      param! :sort_by, String, default: 'id:asc'
    end

    def valid_create?
      param! :material_request, Hash, required: true, blank: false do |p|
        p.param! :code, String, blank: false
        p.param! :delivery_date, Date, blank: false
        p.param! :metadata, Hash, blank: false
      end
    end

    def valid_update?
      param! :material_request, Hash, required: true, blank: false do |p|
        p.param! :delivery_date, Date, blank: false
        p.param! :metadata, Hash, blank: false
      end
    end
  end
end
