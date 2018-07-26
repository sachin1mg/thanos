module Api::Public::V1
  class InventoriesController < ::Api::Public::AuthController
    skip_before_action :valid_action?, only: [:show, :destroy]

    # GET /inventories
    def index
      resources = inventories.filter(index_filters)
      render_serializer scope: resources
    end

    # GET /inventories/1
    def show
      render_serializer scope: inventory
    end

    # POST /inventories
    def create
      inventory = inventories.create!(inventory_params)
      render_serializer scope: inventory
    end

    # PUT /inventories/1
    def update
      inventory.update_attributes!(inventory_update_params)
      render_serializer scope: inventory
    end

    # DELETE /inventories/1
    def destroy
      inventory.destroy!
      api_render json: {}
    end

    private

    def inventory_params
      params.require(:inventory).permit(:sku_id, :batch_id, :location_id,
        :quantity, :cost_price, :selling_price, :metadata
      )
    end

    def inventory_update_params
      params.require(:inventory).permit(:location_id, :quantity, :cost_price, :selling_price)
    end

    def index_filters
      param! :sku_ids, Array do |id, index|
        id.param! index, Integer
      end

      param! :batch_ids, Array do |id, index|
        id.param! index, Integer
      end

      param! :location_ids, Array do |id, index|
        id.param! index, Integer
      end
      param! :cost_price, Float, blank: false
      param! :selling_price, Float, blank: false
      param! :quantity, Integer, blank: false

      params.permit(:quantity, :selling_price, :cost_price, sku_ids: [], batch_ids: [], location_ids: [])
    end

    #####################
    #### VALIDATIONS ####
    #####################

    def valid_index?
      param! :sort_by, String, default: 'id:asc'
    end

    def valid_create?
      param! :inventory, Hash, required: true, blank: false do |p|
        p.param! :sku_id, Integer, required: true, blank: false
        p.param! :batch_id, Integer, required: true, blank: false
        p.param! :location_id, Integer, required: true, blank: false
        p.param! :quantity, Integer, required: true, blank: false
        p.param! :cost_price, Float, required: true, blank: false
        p.param! :selling_price, Float, required: true, blank: false
        p.param! :metadata, Hash, blank: false
      end
    end

    def valid_update?
      param! :inventory, Hash, required: true, blank: false do |p|
        p.param! :sku_id, Integer, blank: false
        p.param! :batch_id, Integer, blank: false
        p.param! :location_id, Integer, blank: false
        p.param! :quantity, Integer, blank: false
        p.param! :cost_price, Float, blank: false
        p.param! :selling_price, Float, blank: false
        p.param! :metadata, Hash, blank: false
      end
    end

    def inventories
      @inventories ||= current_vendor.inventories
    end

    def inventory
      @inventory ||= inventories.find(params[:id])
    end
  end
end
