module Api::Public::V1
  class SalesOrdersController < ::Api::Public::AuthController
    skip_before_action :valid_action?, only: [:destroy, :show]

    def index
      resources = sales_orders.filter(index_filters)
      render_serializer scope: resources, sorting: true
    end

    def show
      render_serializer scope: sales_order
    end

    def create
      sales_order = SalesOrderModule::SalesOrderManager.create!(user: current_user,
                                                                vendor: current_vendor,
                                                                create_params: param_attributes)
      render_serializer scope: sales_order
    end

    def destroy
      sales_order.destroy!
      api_render json: {}
    end

    private

    def param_attributes
      params.require(:sales_order).permit(:order_reference_id, :customer_name, :amount,
                                          :discount, :source, :shipping_label_url, :vendor_id,
                                          sales_order_items: [:price, :quantity, :discount, :sku_id])
    end

    def index_filters
      param! :id, Integer
      param! :status, String, in: SalesOrder.statuses.keys
      param! :order_reference_id, String
      param! :customer_name, String
      param! :from_date, String, transform: :to_date
      param! :to_date, String, transform: :to_date

      params.permit(:id, :status, :order_reference_id, :from_date, :customer_name, :to_date)
    end

    ######################
    #### VALIDATIONS #####
    ######################

    #
    # Validate index action params
    #
    def valid_index?
      param! :sort_by, String, default: 'id:asc'
    end

    #
    # @return [SalesOrder] Sales Order derived from id in params
    #
    def sales_order
      @sales_order ||= sales_orders.find(params[:id])
    end

    def sales_orders
      @sales_orders ||= current_vendor.sales_orders
    end

    #
    # Validate create action params
    #
    def valid_create?
      param! :sales_order, Hash, required: true, blank: false do |h|
        h.param! :order_reference_id, String, required: true, blank: false
        h.param! :customer_name, String, required: true, blank: false
        h.param! :amount, Float, required: true, blank: false
        h.param! :discount, Float, required: true, blank: false
        h.param! :source, String, required: true, blank: false
        h.param! :barcode, String, required: true, blank: false
        h.param! :shipping_label_url, String, required: true, blank: false
        h.param! :sales_order_items, Array, blank: false, required: true do |array|
          array.param! :sku_id, Integer, required: true, blank: false
          array.param! :quantity, Integer, required: true, blank: false
          array.param! :price, Float, required: true, blank: false
          array.param! :discount, Float, required: true, blank: false
        end
      end
    end
  end
end