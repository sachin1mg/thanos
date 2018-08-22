module Api::Public::V1
  class PurchaseReceiptsController < ::Api::Public::AuthController
    skip_before_action :valid_action?, only: [:show]

    # GET /purchase_receipts
    def index
      resources = purchase_receipts.filter(index_filters)
      render_serializer scope: resources.includes(:supplier)
    end

    # GET /purchase_receipts/1
    def show
      render_serializer scope: purchase_receipt
    end

    def create
      purchase_receipt = purchase_receipts.create!(purchase_receipt_create_params)
      render_serializer scope: purchase_receipt
    end

    def update
      purchase_receipt.update_attributes!(purchase_receipt_update_params)
      render_serializer scope: purchase_receipt
    end

    # POST /purchase_receipts/verify
    def verify
      result = ProcurementModule::PurchaseReceiptManager.verify_uploaded_data(
                purchase_order_ids: params[:purchase_order_ids],
                sku_quantities: params[:sku_quantities]
              )
      api_render json: { purchase_order_ids: params[:purchase_order_ids], result: result }
    end

    private

    def purchase_receipt_create_params
      params.require(:purchase_receipt).permit(:supplier_id, :purchase_order_id, :code,
        :total_amount, metadata: params[:purchase_receipt][:metadata]&.keys)
    end

    def purchase_receipt_update_params
      params.require(:purchase_receipt).permit(:total_amount, metadata: params[:purchase_receipt][:metadata]&.keys)
    end

    def purchase_receipts
      @purchase_receipts ||= current_vendor.purchase_receipts
    end

    def purchase_receipt
      @purchase_receipt ||= purchase_receipts.find(params[:id])
    end

    def index_filters
      param! :id, Integer, blank: false
      param! :status, String, blank: false
      param! :supplier_name, String, blank: false
      param! :created_from, Date, blank: false
      param! :created_to, Date, blank: false

      params.permit(:id, :supplier_name, :status, :created_from, :created_to)
    end

    #####################
    #### VALIDATIONS ####
    #####################

    def valid_index?
      param! :sort_by, String, default: 'id:asc'
    end

    def valid_create?
      param! :purchase_receipt, Hash, required: true, blank: false do |p|
        p.param! :supplier_id, Integer, required: true, blank: false
        p.param! :purchase_order_id, Integer, required: true, blank: false
        p.param! :code, String, required: true, blank: false
        p.param! :total_amount, Float, required: true, blank: false
        p.param! :metadata, Hash, blank: false
      end
    end

    def valid_update?
      param! :purchase_receipt, Hash, required: true, blank: false do |p|
        p.param! :total_amount, Float, blank: false
        p.param! :metadata, Hash, blank: false
      end
    end

    #
    # Validate verify action
    #
    def valid_verify?
      param! :purchase_order_ids, Array, required: true, blank: false do |p, i|
        p.param! i, Integer, required: true, blank: false
      end
      param! :sku_quantities, Array, required: true, blank: false do |sq|
        sq.param! :sku_id, Integer, required: true, blank: false
        sq.param! :quantity, Integer, required: true, blank: false
      end
    end
  end
end
