module Api::Public::V1
  class PurchaseReceiptItemsController < ::Api::Public::AuthController
    skip_before_action :valid_action?, only: [:show]

    # GET /purchase_receipt_items
    def index
      resources = purchase_receipt_items.filter(index_filters)
      render_serializer scope: resources
    end

    # GET /purchase_receipt_items/1
    def show
      render_serializer scope: purchase_receipt_item
    end

    def create
      purchase_receipt_item = purchase_receipt.purchase_receipt_items.create!(purchase_receipt_item_create_params)
      render_serializer scope: purchase_receipt_item
    end

    def update
      purchase_receipt_item.update_attributes!(purchase_receipt_item_update_params)
      render_serializer scope: purchase_receipt_item
    end

    private

    def purchase_receipt_item_create_params
      params.require(:purchase_receipt_item).permit(:purchase_order_item_id,
        :sku_id, :batch_id, :received_quantity, :returned_quantity, :price,
        :schedule_date, metadata: params[:purchase_receipt_item][:metadata]&.keys
      )
    end

    def purchase_receipt_item_update_params
      params.require(:purchase_receipt_item).permit(:received_quantity, :returned_quantity,
        :price, :schedule_date, metadata: params[:purchase_receipt_item][:metadata]&.keys)
    end

    def purchase_receipt_items
      @purchase_receipt_items ||= current_vendor.purchase_receipt_items
    end

    def purchase_receipt_item
      @purchase_receipt_item ||= purchase_receipt_items.find(params[:id])
    end

    def purchase_receipt
      @purchase_receipt ||= current_vendor.purchase_receipts.find(params[:purchase_receipt_id])
    end

    def index_filters
      param! :sku_id, Integer, blank: false
      param! :batch_id, Integer, blank: false
      param! :minimum_price, Float, blank: false
      param! :maximum_price, Float, blank: false
      param! :status, String, blank: false
      param! :from_schedule_date, Date, blank: false
      param! :to_schedule_date, Date, blank: false

      params.permit(:sku_id, :batch_id, :minimum_price, :maximum_price, :status,
        :from_schedule_date, :to_schedule_date)
    end

    #####################
    #### VALIDATIONS ####
    #####################

    def valid_index?
      param! :sort_by, String, default: 'id:asc'
    end

    def valid_create?
      param! :purchase_receipt_item, Hash, required: true, blank: false do |p|
        p.param! :sku_id, Integer, required: true, blank: false
        p.param! :batch_id, Integer, required: true, blank: false
        p.param! :received_quantity, Integer, blank: false
        p.param! :returned_quantity, Integer, blank: false
        p.param! :price, Float, required: true, blank: false
        p.param! :schedule_date, Date, blank: false
        p.param! :metadata, Hash, blank: false
      end
    end

    def valid_update?
      param! :purchase_receipt_item, Hash, required: true, blank: false do |p|
        p.param! :received_quantity, Integer, blank: false
        p.param! :returned_quantity, Integer, blank: false
        p.param! :price, Float, blank: false
        p.param! :schedule_date, Date, blank: false
        p.param! :metadata, Hash, blank: false
      end
    end
  end
end
