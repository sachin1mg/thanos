module Api::Public::V1
  class InventoryPickupsController < ::Api::Public::AuthController
    skip_before_action :valid_action?, only: [:destroy, :show]

    def create
      inventory_pickup = InventoryPickup.create!(param_attributes)
      render_serializer scope: inventory_pickup
    end

    def index
      inventory_pickups = InventoryPickup.filter(index_filters)
      render_serializer scope: inventory_pickups, sorting: true
    end

    def show
      render_serializer scope: inventory_pickup
    end

    def destroy
      inventory_pickup.delete
      api_render json: {}
    end

    private

    def param_attributes
      params.permit(:sales_order_item_id, :inventory_id, :metadata)
    end

    def index_filters
      params.permit()
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
      @inventory_pickup ||= InventoryPickup.find(params[:id])
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