module Api::Public::V1
  class SkusController < ::Api::Public::AuthController
    skip_before_action :valid_action?, only: [:show, :destroy]

    # GET /skus
    def index
      render_serializer scope: Sku.scoped
    end

    # GET /skus/1
    def show
      render_serializer scope: sku
    end

    def create
      sku = Sku.build(sku_params)
      sku = InventoryModule::SkuManager.new(sku).create
      render_serializer scope: sku
    end

    def update
      sku.update_attributes!(sku_params)
      render_serializer scope: sku
    end

    # DELETE /skus/1
    def destroy
      sku.destroy
    end

    private

    def sku_params
      params.permit(:onemg_sku_id, :sku_name, :manufacturer_name, :item_group, :uom, :pack_size)
    end

    def index_filters
      param! :onemg_sku_id, String, blank: false
      param! :manufacturer_name, String, blank: false
      param! :item_group, String, blank: false
      param! :uom, String, blank: false

      params.permit(:onemg_sku_id, :manufacturer_name, :item_group, :uom)
    end

    #####################
    #### VALIDATIONS ####
    #####################

    def valid_index?
      param! :sort_by, String, default: 'id:asc'
    end

    def valid_create?
      param! :sku, Hash, required: true, blank: false do |p|
        p.param! :onemg_sku_id, String, required: true, blank: false
        p.param! :sku_name, String, required: true, blank: false
        p.param! :manufacturer_name, String, required: true, blank: false
        p.param! :item_group, String, required: true, blank: false
        p.param! :uom, String, required: true, blank: false
        p.param! :pack_size, Integer, required: true, blank: false
      end
    end

    def valid_update?
      param! :sku, Hash, required: true, blank: false do |p|
        p.param! :onemg_sku_id, String, blank: false
        p.param! :sku_name, String, blank: false
        p.param! :manufacturer_name, String, blank: false
        p.param! :item_group, String, blank: false
        p.param! :uom, String, blank: false
        p.param! :pack_size, Integer, blank: false
      end
    end

    def sku
      @sku ||= Sku.find(params[:id])
    end
  end
end
