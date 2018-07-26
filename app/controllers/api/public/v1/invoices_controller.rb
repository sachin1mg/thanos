module Api::Public::V1
  class InvoicesController < ::Api::Public::AuthController
    skip_before_action :valid_action?

    def index
      api_render json: {a: 'namaste'}
    end

    private

    def index_filters
      # param! :id, Integer, blank: false
      # param! :status, String, in: SalesOrder.statuses.keys, blank: false
      # param! :order_reference_id, String, blank: false
      # param! :customer_name, String, blank: false
      # param! :from_date, String, transform: :to_date
      # param! :to_date, String, transform: :to_date

      # params.permit(:id, :status, :order_reference_id, :from_date, :customer_name, :to_date)
    end

    #
    # @return [SalesOrder] Sales Order derived from sales_order_id in params
    #
    def sales_order
      @sales_order ||= SalesOrder.find(params[:sales_order_id])
    end
  end
end
