module Api::Public::V1
  class MaterialRequestItemsController < ::Api::Public::AuthController
    skip_before_action :valid_action?, only: [:show, :destroy]

    # GET /material_request_items
    def index
      resources = material_request_items.filter(index_filters)
      render_serializer scope: resources
    end

    # GET /material_request_items/1
    def show
      render_serializer scope: location
    end

    def create
      location = material_request_items.create!(location_params)
      render_serializer scope: location
    end

    def update
      location.update_attributes!(location_params)
      render_serializer scope: location
    end

    # DELETE /material_request_items/1
    def destroy
      location.destroy!
      api_render json: {}
    end

    private

    def location_params
      params.require(:location).permit(:aisle, :rack, :slab, :bin)
    end

    def material_request_items
      @material_request_items ||= current_vendor.material_request_items
    end

    def location
      @location ||= material_request_items.find(params[:id])
    end

    def index_filters
      param! :aisle, String, blank: false
      param! :rack, String, blank: false
      param! :slab, String, blank: false
      param! :bin, String, blank: false

      params.permit(:aisle, :slab, :bin, :rack)
    end

    #####################
    #### VALIDATIONS ####
    #####################

    def valid_index?
      param! :sort_by, String, default: 'id:asc'
    end

    def valid_create?
      param! :location, Hash, required: true, blank: false do |p|
        p.param! :aisle, String, required: true, blank: false
        p.param! :rack, String, required: true, blank: false
        p.param! :slab, String, required: true, blank: false
        p.param! :bin, String, required: true, blank: false
      end
    end

    def valid_update?
      pparam! :location, Hash, required: true, blank: false do |p|
        p.param! :aisle, String, blank: false
        p.param! :rack, String, blank: false
        p.param! :slab, String, blank: false
        p.param! :bin, String, blank: false
      end
    end
  end
end
