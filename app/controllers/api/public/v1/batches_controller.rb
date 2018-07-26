module Api::Public::V1
  class BatchesController < ::Api::Public::AuthController
    skip_before_action :valid_action?

    # GET /batches
    def index
      batches = Batch.filter(index_filters)
      render_serializer scope: batches
    end

    # GET /batches/1
    def show
      render_serializer scope: batch
    end

    # POST /batches
    def create
      batch = Batch.create!(batch_params)
      render_serializer scope: batch
    end

    def update
      batch.update_attributes!(batch_params)
      render_serializer scope: batch
    end

    # DELETE /batches/1
    def destroy
      batch.destroy!
      api_render json: {}
    end

    private
    def batch_params
      params.require(:batch).permit(:sku_id, :mrp, :manufacturing_date, :expiry_date, :metadata)
    end

    def index_filters
      params.permit(:sku_id)
    end

    def batch
      @batch ||= Batch.find(params[:id])
    end
  end
end

