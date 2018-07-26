module Api::Public::V1
  class InvoicesController < ::Api::Public::AuthController
    skip_before_action :valid_action?

    def index
      invoices = sales_order.invoice
      render_serializer scope: invoices
    end

    def show
      invoice = Invoice.find_by!(sales_order: sales_order, id: params[:id])
      render_serializer scope: invoice
    end

    private

    #
    # @return [SalesOrder] Sales Order derived from sales_order_id in params
    #
    def sales_order
      @sales_order ||= SalesOrder.find(params[:sales_order_id])
    end
  end
end
