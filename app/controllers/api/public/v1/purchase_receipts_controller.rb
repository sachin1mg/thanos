module Api::Public::V1
  class PurchaseReceiptsController < ::Api::Public::AuthController
    skip_before_action :valid_action?, only: [:show, :destroy]

    # GET /purchase_receipts
    def index
      resources = purchase_receipts.filter(index_filters)
      render_serializer scope: resources
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

    # DELETE /purchase_receipts/1
    def destroy
      purchase_receipt.destroy!
      api_render json: {}
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
      param! :supplier_id, Integer, blank: false

      params.permit(:supplier_id)
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
  end
end
