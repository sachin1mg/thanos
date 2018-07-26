module Api::Public::V1
  class SalesOrderItemsController < ::Api::Public::AuthController
    skip_before_action :valid_action?, only: [:destroy, :show]

    def create
      sales_order_item = SalesOrderItem.create!(param_attributes)
      render_serializer scope: sales_order_item
    end

    def index
      sales_order_items = SalesOrderItem.filter(index_filters)
      render_serializer scope: sales_order_items, sorting: true
    end

    def show
      render_serializer scope: sales_order_item
    end

    def destroy
      sales_order_item.delete
      api_render json: {}
    end

    private

    def param_attributes
      params.permit(:sku_id, :sales_order_id, :price, :discount)
    end

    def index_filters
      params.permit(:sales_order_id)
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
    def sales_order_item
      @sales_order_item ||= sales_order.sales_order_items.find(params[:id])
    end

    def sales_order
      @sales_order ||= SalesOrder.find(params[:sales_order_id])
    end

    #
    # Validate create action params
    #
    def valid_create?
      param! :sku_id, Integer, blank: false
      param! :price, Float, blank: false
      param! :discount, Float, blank: false
    end
  end
end