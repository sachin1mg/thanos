module Api::Public::V1
  class PurchaseOrdersController < ::Api::Public::AuthController
    skip_before_action :valid_action?, only: [:show]

    # GET /purchase_orders
    def index
      resources = purchase_orders.filter(index_filters)
      respond_to do |format|
        format.json { render_serializer scope: resources.includes(:supplier) }
        format.csv do
          send_data(
            ProcurementModule::PurchaseOrdersManager.new(resources).index_csv,
            filename: "purchase-orders-#{Time.zone.now.to_i}.csv"
          )
        end
      end
    end

    # GET /purchase_orders/1
    def show
      respond_to do |format|
        format.json { render_serializer scope: purchase_order }
        format.csv do
          send_data(
            ProcurementModule::PurchaseOrderManager.new(purchase_order).to_csv,
            filename: "purchase_order-#{purchase_order.id}.csv"
          )
        end
      end
    end

    #
    # This api will create only bulk purchase orders.
    #
    def create
      purchase_order = ProcurementModule::PurchaseOrderManager.create!(user: current_user,
                                                                       params: purchase_order_create_params)

      render_serializer scope: purchase_order
    end

    def update
      updated_purchase_order = ProcurementModule::PurchaseOrderManager
                                 .new(purchase_order)
                                 .update(purchase_order_update_params)
      render_serializer scope: updated_purchase_order
    end

    private

    def purchase_order_create_params
      params.require(:purchase_order).permit(:code, :supplier_id,
             purchase_order_items: [:sku_id, :quantity, :price, :schedule_date])
    end

    def purchase_order_update_params
      params.require(:purchase_order).permit(:status)
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
      param! :id, Integer, blank: false
      param! :status, String, blank: false
      param! :supplier_name, String, transform: ->(supplier_name){ supplier_name.strip }, blank: false
      param! :created_from, Date, blank: false
      param! :created_to, Date, blank: false

      params.permit(:id, :status, :supplier_name, :created_from, :created_to)
    end

    #####################
    #### VALIDATIONS ####
    #####################

    def valid_index?
      param! :sort_by, String, default: 'id:asc'
    end

    def valid_create?
      param! :purchase_order, Hash, required: true, blank: false do |p|
        p.param! :supplier_id, Integer, required: true, blank: false
        p.param! :code, String, required: true, blank: false
        p.param! :purchase_order_items, Array, required: true, blank: false do |s|
          s.param! :sku_id, Integer, required: true, blank: false
          s.param! :quantity, Integer, min: 0, required: true, blank: false
          s.param! :price, Float, min: 0, required: true, blank: false
          s.param! :schedule_date, Date, required: true, blank: false
        end
      end
    end

    def valid_update?
      param! :purchase_order, Hash, required: true, blank: false do |p|
        p.param! :status, String, in: %w(cancelled closed), required: true, blank: false
      end
    end
  end
end
