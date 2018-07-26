module Api::Public::V1
  class InventoriesController < ::Api::Public::AuthController
    # GET /inventories
    def index
      render json: Inventory.all
    end

    # GET /inventories/1
    def show
      render json: inventory
    end

    def create
    end

    def update
    end

    # DELETE /inventories/1
    def destroy
      inventory.destroy
    end

    private

    def inventory
      @inventory ||= Inventory.find(params[:id])
    end
  end
end
