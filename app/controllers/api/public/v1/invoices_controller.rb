module Api::Public::V1
  class InvoicesController < ::Api::Public::AuthController
    skip_before_action :valid_action?

    def index
      invoices = sales_order.invoices
      render_serializer scope: invoices
    end

    def show
      render_serializer scope: invoice
    end

    private

    #
    # @return [SalesOrder] Sales Order derived from sales_order_id in params
    #
    def sales_order
      @sales_order ||= SalesOrder.find(params[:sales_order_id])
    end

    #
    # @return [Invoice] Invoice derived from id in params
    #
    def invoice
      @invoice ||= sales_order.invoices.find(params[:id])
    end
  end
end
