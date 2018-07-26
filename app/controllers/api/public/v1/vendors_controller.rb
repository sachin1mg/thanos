module Api::Public::V1
  class VendorsController < ::Api::Public::AuthController
    skip_before_action :valid_action?

    # GET /vendors
    def index
      vendors = Vendor.filters(index_filters)
      render_serializer scope: vendors
    end

    # GET /vendors/1
    def show
      render_serializer scope: vendor
    end

    # POST /vendors
    def create
      vendor = InventoryModule::VendorManager.new(Vendor.new(vendor_params)).create
      render_serializer scope: vendor
    end

    # PUT /vendors/1
    def update
      vendor = vendor_manager.update(vendor_params)
      render_serializer scope: vendor
    end

    # DELETE /vendors/1
    def destroy
      vendor.destroy
    end

    private

    def vendor
      @vendor ||= Vendor.find(params[:id])
    end

    def vendor_params
      params.require(:vendor).permit(:name, :status, :metadata, :invoice_number_template)
    end

    def vendor_manager
      @vendor_manager ||= InventoryModule::VendorManager.new(vendor)
    end

    def index_filters
    end
  end
end
