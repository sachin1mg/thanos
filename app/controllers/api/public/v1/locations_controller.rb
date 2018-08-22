module Api::Public::V1
  class LocationsController < ::Api::Public::AuthController
    skip_before_action :valid_action?, only: :show

    # GET /locations
    def index
      resources = locations.filter(index_filters)
      render_serializer scope: resources
    end

    # GET /locations/1
    def show
      render_serializer scope: location
    end

    # POST /locations
    def create
      location = locations.create!(location_params)
      render_serializer scope: location
    end

    # PUT /locations/1
    def update
      location.update_attributes!(location_params)
      render_serializer scope: location
    end

    private

    #
    # Strong parameters for create and update action
    #
    def location_params
      params.require(:location).permit(:aisle, :rack, :slab, :bin)
    end

    #
    # @return [Location::ActiveRecord_Associations_CollectionProxy] Location for current vendor
    #
    def locations
      @locations ||= current_vendor.locations
    end

    #
    # @return [Location] Location filtered by id in params
    #
    def location
      @location ||= locations.find(params[:id])
    end

    #
    # Filters for index action
    #
    def index_filters
      param! :aisle, String, blank: false
      param! :rack, String, blank: false
      param! :slab, String, blank: false
      param! :bin, String, blank: false

      params.permit(:aisle, :slab, :bin, :rack)
    end

    #####################
    #### VALIDATIONS ####
    #####################

    #
    # Validate index action
    #
    def valid_index?
      param! :sort_by, String, default: 'id:asc'
    end

    #
    # Validate create action
    #
    def valid_create?
      param! :location, Hash, required: true, blank: false do |p|
        p.param! :aisle, String, required: true, blank: false
        p.param! :rack, String, required: true, blank: false
        p.param! :slab, String, required: true, blank: false
        p.param! :bin, String, required: true, blank: false
      end
    end

    #
    # Validate update action
    #
    def valid_update?
      param! :location, Hash, required: true, blank: false do |p|
        p.param! :aisle, String, blank: false
        p.param! :rack, String, blank: false
        p.param! :slab, String, blank: false
        p.param! :bin, String, blank: false
      end
    end
  end
end
