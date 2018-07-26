module Api::Public::V1
  class SalesOrdersController < ::Api::Public::AuthController
    def index
      sales_orders = SalesOrder.all.filter(index_filters)
      render_serializer scope: sales_orders, sorting: true
    end

    def show
      after_serialize = Proc.new do |data|
                          data[:item_details] = sales_order.sales_order_items
                          data
                        end

      render_serializer scope: sales_order, after_serialize: after_serialize
    end

    private

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
    # Validate show action params
    #
    def valid_show?
      param! :id, Integer, required: true, blank: false
    end

    #
    # 
    #
    def sales_order
      @sales_order ||= SalesOrder.find(params[:id])
    end
  end
end