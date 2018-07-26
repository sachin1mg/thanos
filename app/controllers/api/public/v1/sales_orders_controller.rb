module Api::Public::V1
  class SalesOrdersController < ::Api::Public::AuthController
    skip_before_action :valid_action?, only: [:destroy, :show]

    def create
      sales_order = SalesOrder.create!(param_attributes)
      render_serializer scope: sales_order
    end

    def index
      sales_orders = SalesOrder.all.filter(index_filters)
      render_serializer scope: sales_orders, sorting: true
    end

    def show
      render_serializer scope: sales_order
    end

    def destroy
      sales_order.delete
    end

    private

    def param_attributes
      params.permit(:vendor_id, :order_reference_id, :customer_name, :amount, :discount, :source, :barcode, :shipping_label_url)
    end

    def index_filters
      param! :id, Integer, blank: false
      param! :status, String, in: SalesOrder.statuses.keys, blank: false
      param! :order_reference_id, String, blank: false
      param! :customer_name, String, blank: false
      param! :from_date, String, transform: :to_date
      param! :to_date, String, transform: :to_date

      params.permit(:id, :status, :order_reference_id, :from_date, :customer_name, :to_date)
    end

    ######################
    #### VALIDATIONS ####
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
      @sales_order ||= SalesOrder.find(params[:id])
    end

    #
    # Validate create action params
    #
    def valid_create?
      param! :order_reference_id, String, required: true, blank: false
      param! :customer_name, String, blank: false
      param! :amount, Float, blank: false
      param! :discount, Float, blank: false
      param! :source, String, blank: false
      param! :barcode, String, blank: false
      param! :shipping_label_url, String, blank: false
    end
  end
end