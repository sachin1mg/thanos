module Api::Public::V1
  class MaterialRequestsController < ::Api::Public::AuthController
    skip_before_action :valid_action?, only: :show

    # GET /material_requests
    def index
      resources = material_requests.filter(index_filters).includes(:sku)
      respond_to do |format|
        format.json { render_serializer scope: resources }
        format.csv do
          send_data(
            ProcurementModule::MaterialRequestManager.index_csv(resources),
            filename: "material-requests-#{Time.zone.now.to_i}.csv"
          )
        end
      end
    end

    # GET /material_requests/1
    def show
      render_serializer scope: material_request
    end

    private

    #
    # @return [MaterialRequest::ActiveRecord_Associations_CollectionProxy] Material Requests for current vendor
    #
    def material_requests
      current_vendor.material_requests
    end

    #
    # @return [MaterialRequest] Material Request derived from id provided in params
    #
    def material_request
      @material_request ||= material_requests.find(params[:id])
    end

    #
    # Filters for index action
    #
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

    #
    # Validations for index action
    #
    def valid_index?
      param! :sort_by, String, default: 'id:asc'
    end
  end
end
