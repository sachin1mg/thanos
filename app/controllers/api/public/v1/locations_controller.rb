module Api::Public::V1
  class LocationsController < ::Api::Public::AuthController
    # GET /locations
    def index
      resources = Location.all
      render_serializer scope: resources
    end

    # GET /locations/1
    def show
      render json: location
    end

    def create
      location = InventoryModule::LocationManager.create(location_params)
      render_serializer scope: location
    end

    def update
      location = location_manager.update(location_params)
      render_serializer scope: location
    end

    # DELETE /locations/1
    def destroy
      location.destroy
    end

    private

    def location

      @location ||= Location.find(params[:id])
    end

    def location_params
      params.permit(:vendor_id, :aisle, :rack, :slab, :bin)
    end

    def location_manager
      @location_manager ||= InventoryModule::LocationManager.new(location)
    end
  end
end
