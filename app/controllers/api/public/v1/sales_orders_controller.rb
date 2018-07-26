module Api::Public::V1
  class SalesOrdersController < ::Api::Public::AuthController
    def index
      sales_orders = SalesOrder.all.filter(index_filters)
      render_serializer scope: sales_orders, sorting: true
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
  end
end