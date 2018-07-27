module Api::Public::V1
  class PurchaseOrdersController < ::Api::Public::AuthController
    skip_before_action :valid_action?, only: [:show, :destroy]

    # GET /purchase_orders
    def index
      resources = purchase_orders.filter(index_filters)
      render_serializer scope: resources
    end

    # GET /purchase_orders/1
    def show
      render_serializer scope: purchase_order
    end

    def create
      purchase_order = purchase_orders.create!(purchase_order_create_params)
      render_serializer scope: purchase_order
    end

    def update
      purchase_order.update_attributes!(purchase_order_update_params)
      render_serializer scope: purchase_order
    end

    # DELETE /material_requests/1
    def destroy
      purchase_order.destroy!
      api_render json: {}
    end

    private

    def purchase_order_create_params
      params.require(:purchase_order).permit(:code, :delivery_date,
        metadata: params[:purchase_order][:metadata]&.keys, material_request_ids: [])
    end

    def purchase_order_update_params
      params.require(:purchase_order).permit(
        metadata: params[:purchase_order][:metadata]&.keys,
        material_request_ids: []
      )
    end

    def purchase_orders
      current_vendor.purchase_orders
    end

    def supplier
      @supplier ||= Supplier.find(params[:supplier_id])
    end

    def purchase_order
      @purchase_order ||= purchase_orders.find(params[:id])
    end

    def index_filters
      param! :type, String, blank: false
      param! :supplier_id, Integer, blank: false
      param! :to_delivery_date, Date, blank: false
      param! :from_delivery_date, Date, blank: false

      params.permit(:type, :to_delivery_date, :from_delivery_date, :supplier_id)
    end

    #####################
    #### VALIDATIONS ####
    #####################

    def valid_index?
      param! :sort_by, String, default: 'id:asc'
    end

    def valid_create?
      param! :purchase_order, Hash, required: true, blank: false do |p|
        p.param! :code, String, blank: false
        p.param! :delivery_date, Date, blank: false
        p.param! :metadata, Hash, blank: false
        p.param! :material_request_ids, Array, blank: false
      end
    end

    def valid_update?
      param! :purchase_order, Hash, required: true, blank: false do |p|
        p.param! :metadata, Hash, blank: false
        p.param! :material_request_ids, blank: false
      end
    end
  end
end
