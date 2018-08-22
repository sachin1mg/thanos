module Api::Public::V1
  class PurchaseOrderItemsController < ::Api::Public::AuthController
    skip_before_action :valid_action?, only: [:show]

    # GET /purchase_order_items
    def index
      resources = purchase_order_items.filter(index_filters)
      render_serializer scope: resources
    end

    # GET /purchase_order_items/1
    def show
      render_serializer scope: purchase_order_item
    end

    def create
      purchase_order_item = purchase_order_items.create!(purchase_order_item_create_params)
      render_serializer scope: purchase_order_item
    end

    def update
      purchase_order_item.update_attributes!(purchase_order_items_update_params)
      render_serializer scope: purchase_order_item
    end

    private

    def purchase_order_item_create_params
      params.require(:purchase_order_item).permit(:material_request_item_id,
        :sku_id, :quantity, :price, :schedule_date,
        metadata: params[:purchase_order_item][:metadata]&.keys)
    end

    def purchase_order_item_update_params
      params.require(:purchase_order_item).permit(:quantity, :price, :schedule_date,
        metadata: params[:purchase_order_item][:metadata]&.keys)
    end

    def purchase_order_items
      @purchase_order_items ||= purchase_order.purchase_order_items
    end

    def purchase_order_item
      @purchase_order_item ||= purchase_order_items.find(params[:id])
    end

    def purchase_order
      @purchase_order ||= current_vendor.purchase_orders.find(params[:purchase_order_id])
    end

    def index_filters
      param! :sku_id, Integer, blank: false
      param! :status, String, blank: false
      param! :to_schedule_date, Date, blank: false
      param! :from_schedule_date, Date, blank: false
      param! :minimum_price, Float, blank: false
      param! :maximum_price, Float, blank: false

      params.permit(:sku_id, :status, :to_schedule_date,
        :from_schedule_date, :minimum_price, :maximum_price)
    end

    #####################
    #### VALIDATIONS ####
    #####################

    def valid_index?
      param! :sort_by, String, default: 'id:asc'
    end

    def valid_create?
      param! :purchase_order_item, Hash, required: true, blank: false do |p|
        p.param! :sku_id, Integer, required: true, blank: false
        p.param! :material_request_item_id, Integer, required: true, blank: false
        p.param! :quantity, Integer, blank: false
        p.param! :price, Float, blank: false
        p.param! :schedule_date, Date, blank: false
        p.param! :metadata, Hash, blank: false
      end
    end

    def valid_update?
      param! :purchase_order_item, Hash, required: true, blank: false do |p|
        p.param! :quantity, Integer, blank: false
        p.param! :price, Float, blank: false
        p.param! :schedule_date, Date, blank: false
        p.param! :metadata, Hash, blank: false
      end
    end
  end
end
