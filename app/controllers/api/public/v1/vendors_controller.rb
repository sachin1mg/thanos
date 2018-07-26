module Api::Public::V1
  class VendorsController < ::Api::Public::AuthController
    skip_before_action :valid_action?

    # GET /vendors
    def index
      vendors = Vendor.filter(index_filters)
      render_serializer scope: vendors
    end

    # GET /vendors/1
    def show
      render_serializer scope: vendor
    end

    # POST /vendors
    def create
      vendor = Vendor.create!(vendor_params)
      render_serializer scope: vendor
    end

    # PUT /vendors/1
    def update
      vendor.update_attributes!(vendor_params)
      render_serializer scope: vendor
    end

    # DELETE /vendors/1
    def destroy
      vendor.destroy!
      api_render json: {}
    end

    private

    def vendor_params
      params.require(:vendor).permit(:name, :status, :metadata, :invoice_number_template)
    end

    def index_filters
    end

    def vendor
      @vendor ||= Vendor.find(params[:id])
    end
  end
end
