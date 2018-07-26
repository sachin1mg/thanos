module Api::Public::V1
  class InventoriesController < ::Api::Public::AuthController
    skip_before_action :valid_action?

    # GET /inventories
    def index
      inventories = Inventory.filters(index_filters)
      render_serializer scope: inventories
    end

    # GET /inventories/1
    def show
      render_serializer scope: inventory
    end

    # POST /inventories
    def create
      inventory = InventoryModule::InventoryManager.create(inventory_params)
      render_serializer scope: inventory
    end

    # PUT /inventories/1
    def update
      inventory = inventory_manager.update(inventory_params)
      render_serializer scope: inventory
    end

    # DELETE /inventories/1
    def destroy
      inventory.destroy
    end

    private

    def inventory
      @inventory ||= Inventory.find(params[:id])
    end

    def inventory_params
      params.require(:inventory).permit(:vendor_id, :sku_id, :batch_id,
        :location_id, :quantity, :cost_price, :selling_price, :metadata
      )
    end

    def inventory_manager
      @inventory_manager ||= InventoryModule::InventoryManager.new(inventory)
    end

    def index_filters
    end
  end
end
