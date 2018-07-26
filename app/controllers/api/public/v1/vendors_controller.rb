module Api::Public::V1
  class VendorsController < ::Api::Public::AuthController
    # GET /vendors
    def index
      render json: Vendor.all
    end

    # GET /vendors/1
    def show
      render json: vendor
    end

    def create
    end

    def update
    end

    # DELETE /vendors/1
    def destroy
      vendor.destroy
    end

    private

    def vendor
      @vendor ||= Vendor.find(params[:id])
    end
  end
end
