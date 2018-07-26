module Api::Public::V1
  class InventoriesController < ::Api::Public::AuthController
    skip_before_action :valid_action?

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
      inventory.update_attributes!(inventory_params)
      render_serializer scope: inventory
    end

    # DELETE /inventories/1
    def destroy
      inventory.destroy!
      api_render json: {}
    end

    private

    def inventory_params
      params.require(:inventory).permit(:vendor_id, :sku_id, :batch_id,
        :location_id, :quantity, :cost_price, :selling_price, :metadata
      )
    end

    def index_filters
    end

    def inventories
      @inventories ||= current_vendor.inventories
    end

    def inventory
      @inventory ||= inventories.find(params[:id])
    end
  end
end
