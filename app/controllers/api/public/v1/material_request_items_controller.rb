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
      render_serializer scope: material_request_item
    end

    def create
      material_request_item = material_request_items.create!(material_request_item_create_params)
      render_serializer scope: material_request_item
    end

    def update
      material_request_item.update_attributes!(material_request_item_update_params)
      render_serializer scope: material_request_item
    end

    # DELETE /material_request_items/1
    def destroy
      material_request_item.destroy!
      api_render json: {}
    end

    private

    def material_request_item_create_params
      params.require(:material_request_item).permit(:sku_id, :quantity, :schedule_date, :metadata)
    end

    def material_request_item_update_params
      params.require(:material_request_item).permit(:quantity, :schedule_date, :metadata)
    end

    def material_request_items
      @material_request_items ||= material_request.material_request_items
    end

    def material_request_item
      @material_request_item ||= material_request_items.find(params[:id])
    end

    def material_request
      @material_request ||= MaterialRequest.find(params[:material_request_id])
    end

    def index_filters
      param! :sku_id, Integer, blank: false
      param! :quantity, Integer, blank: false
      param! :schedule_date, Date, blank: false

      params.permit(:sku_id, :quantity, :schedule_date)
    end

    #####################
    #### VALIDATIONS ####
    #####################

    def valid_index?
      param! :sort_by, String, default: 'id:asc'
    end

    def valid_create?
      param! :material_request_item, Hash, required: true, blank: false do |p|
        param! :sku_id, Integer, required: true, blank: false
        param! :quantity, Integer, blank: false
        param! :schedule_date, Date, blank: false
        param! :metadata, Hash, blank: false
      end
    end

    def valid_update?
      param! :material_request_item, Hash, required: true, blank: false do |p|
        param! :quantity, Integer, blank: false
        param! :schedule_date, Date, blank: false
        param! :metadata, Hash, blank: false
      end
    end
  end
end
