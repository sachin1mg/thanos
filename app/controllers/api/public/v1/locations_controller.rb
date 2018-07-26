module Api::Public::V1
  class LocationsController < ::Api::Public::AuthController
    # GET /locations
    def index
      locations = locations.filter(index_filters)
      render_serializer scope: locations
    end

    # GET /locations/1
    def show
      render_serializer scope: location
    end

    def create
      location = locations.create!(location_params)
      render_serializer scope: location
    end

    def update
      location.update_attributes!(location_params)
      render_serializer scope: location
    end

    # DELETE /locations/1
    def destroy
      location.destroy!
      api_render json: {}
    end

    private

    def location_params
      params.require(:location).permit(:aisle, :rack, :slab, :bin)
    end

    def locations
      @locations ||= current_vendor.locations
    end

    def location
      @location ||= locations.find(params[:id])
    end

    def index_filters
    end
  end
end
