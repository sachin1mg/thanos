module Api::Public::V1
  class SkusController < ::Api::Public::AuthController
    # GET /skus
    def index
      render json: Sku.scoped
    end

    # GET /skus/1
    def show
      render json: sku
    end

    def create
      sku = Sku.build(sku_params)
      sku = InventoryModule::SkuManager.new(sku).create
      render_serializer scope: sku
    end

    def update
      sku = sku_manager.update(sku_params)
      render_serializer scope: sku
    end

    # DELETE /skus/1
    def destroy
      sku.destroy
    end

    private

    def sku
      @sku ||= Sku.find(params[:id])
    end

    def sku_manager
      @sku_manager ||= InventoryModule::SkuManager.new(sku)
    end

    def sku_params
      params.permit(:onemg_sku_id, :sku_name, :manufacturer_name, :item_group, :uom, :pack_size)
    end
  end
end
