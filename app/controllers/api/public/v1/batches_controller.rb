module Api::Public::V1
  class BatchesController < ::Api::Public::AuthController
    skip_before_action :valid_action?

    # GET /batches
    def index
      batches = Batch.filters(index_filters)
      render_serializer scope: batches
    end

    # GET /batches/1
    def show
      render_serializer scope: batch
    end

    # POST /batches
    def create
      batch = InventoryModule::BatchManager.create(batch_params)
      render_serializer scope: batch
    end

    def update
      batch = batch_manager.update(batch_params)
      render_serializer scope: batch
    end

    # DELETE /batches/1
    def destroy
      batch.destroy
    end

    private

    def batch
      @batch ||= Batch.find(params[:id])
    end

    def batch_params
      params.require(:batch).permit(:sku_id, :mrp, :manufacturing_date, :expiry_date, :metadata)
    end

    def batch_manager
      @batch_manager ||= InventoryModule::BatchManager.new(batch)
    end

    def index_filters
    end
  end
end

