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
      vendor = Vendor.find(params[:vendor_id])
      location = vendor.locations.build(location_params)
      location = InventoryModule::LocationManager.new(location).create
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
      vendor = Vendor.find(params[:vendor_id])
      @location ||= vendor.location.find(params[:id])
    end

    def location_params
      params.permit(:aisle, :rack, :slab, :bin)
    end

    def location_manager
      @location_manager ||= InventoryModule::LocationManager.new(location)
    end
  end
end
