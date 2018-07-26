module Api::Public::V1
  class SkusController < ::Api::Public::AuthController
    # GET /skus
    def index
      render json: Sku.all
    end

    # GET /skus/1
    def show
      render json: sku
    end

    def create
    end

    def update
    end

    # DELETE /skus/1
    def destroy
      sku.destroy
    end

    private

    def sku
      @sku ||= Sku.find(params[:id])
    end
  end
end
