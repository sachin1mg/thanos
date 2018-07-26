module Api::Public::V1
  class LocationsController < ::Api::Public::AuthController
    # GET /locations
    def index
      render json: Location.all
    end

    # GET /locations/1
    def show
      render json: location
    end

    def create
    end

    def update
    end

    # DELETE /locations/1
    def destroy
      location.destroy
    end

    private

    def location
      @location ||= Location.find(params[:id])
    end
  end
end
