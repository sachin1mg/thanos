module Api::Public::V1
  class InvoicesController < ::Api::Public::AuthController
    skip_before_action :valid_action?, except: [:create]

    def index
      invoices = sales_order.invoices
      render_serializer scope: invoices
    end

    def show
      render_serializer scope: invoice
    end

    def create
      invoice = sales_order.invoices.create!(param_attributes)
      render_serializer scope: invoice
    end

    def destroy
      invoice.destroy!
      api_render json: {}
    end

    private

    #
    # Strong params
    #
    def param_attributes
      params.permit(:number, :date, :attachment)
    end

    #
    # Validate create action params
    #
    def valid_create?
      param! :number, String, required: true, blank: false
      param! :date, Date, required: true, default: Date.today
      # [TODO nipunmanocha] Validate attachment as file
    end

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
