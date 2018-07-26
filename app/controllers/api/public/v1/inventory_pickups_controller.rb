module Api::Public::V1
  class InventoryPickupsController < ::Api::Public::AuthController
    skip_before_action :valid_action?, only: [:destroy, :show]

    def create
      sales_order_item = sales_order.sales_order_items.find(params[:sales_order_item_id])
      inventory_pickup = sales_order_item.inventory_pickups.create!(param_attributes)
      render_serializer scope: inventory_pickup
    end

    def index
      filter_inventory_pickups = inventory_pickups.filter(index_filters)
      render_serializer scope: filter_inventory_pickups, sorting: true
    end

    def show
      render_serializer scope: inventory_pickup
    end

    def destroy
      inventory_pickup.destroy!
      api_render json: {}
    end

    private

    def param_attributes
      params.permit(:sales_order_item_id, :inventory_id, :metadata)
    end

    def index_filters
      {}
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

    def inventory_pickup
      @inventory_pickup ||= inventory_pickups.find(params[:id])
    end

    def sales_order
      @sales_order ||= SalesOrder.find(params[:sales_order_id])
    end

    def inventory_pickups
      @inventory_pickups ||= sales_order.inventory_pickups
    end

    #
    # Validate create action params
    #
    def valid_create?
      param! :sales_order_item_id, Integer, required: true, blank: false
      param! :inventory_id, Integer, required: true, blank: false
      param! :metadata, Hash, blank: false
    end
  end
end