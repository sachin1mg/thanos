module Api::Public::V1
  class BatchesController < ::Api::Public::AuthController
    skip_before_action :valid_action?, only: [:show, :destroy]

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
      batch = sku.batches.create!(batch_params)
      render_serializer scope: batch
    end

    # PUT /batches/1
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
      params.require(:batch).permit(:code, :mrp, :manufacturing_date, :expiry_date, :metadata)
    end

    ######################
    #### VALIDATIONS ####
    ######################

    def valid_index?
      param! :sort_by, String, default: 'id:asc'
    end

    def valid_create?
      param! :batch, Hash, required: true, blank: false do |p|
        p.param! :code, String, required: true, blank: false
        p.param! :mrp, Float, required: true, blank: false
        p.param! :manufacturing_date, Date, required: true, blank: false
        p.param! :expiry_date, Date, required: true, blank: false
      end
    end

    def valid_update?
      param! :batch, Hash, required: true, blank: false do |p|
        p.param! :code, String, required: true, blank: false
        p.param! :mrp, Float, blank: false
        p.param! :manufacturing_date, Date, blank: false
        p.param! :expiry_date, Date, blank: false
      end
    end

    def index_filters
      param! :sku_ids, Array do |id, index|
        id.param! index, Integer
      end
      param! :manufacturing_date, Date, blank: false
      param! :manufacturer_name, String, transform: :strip
      param! :sku_name, String, transform: :strip
      param! :expiry_date, Date, blank: false
      param! :mrp, Float, blank: false

      params.permit(:manufacturing_date, :manufacturer_name, :sku_name, :expiry_date, :mrp, sku_ids: [])
    end

    def batch
      @batch ||= Batch.find(params[:id])
    end

    def sku
      @sku ||= Sku.find(params[:sku_id])
    end
  end
end
