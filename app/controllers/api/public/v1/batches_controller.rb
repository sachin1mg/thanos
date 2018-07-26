module Api::Public::V1
  class BatchesController < ::Api::Public::AuthController
    # GET /batches
    def index
      render json: Batch.all
    end

    # GET /batches/1
    def show
      render json: batch
    end

    # POST /movies
    def create
      batch = Batch.create(batch_params)
      render json: batch
    end

    def update
    end

    # DELETE /batches/1
    def destroy
      batch.destroy
    end

    private

    def batch
      @batch ||= Batch.find(params[:id])
    end
  end
end

