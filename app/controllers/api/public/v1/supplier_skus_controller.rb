module Api::Public::V1
  class SupplierSkusController < ::Api::Public::AuthController
    skip_before_action :valid_action?, only: [:index, :show]

    def index
      supplier_skus = SupplierSku.filter(index_filters)
      render_serializer scope: supplier_skus
    end

    def show
      render_serializer scope: supplier_sku
    end

    def create
      supplier_sku = SupplierSku.create!(params_attributes.merge(supplier: supplier, sku: sku))
      render_serializer scope: supplier_sku
    end

    def update
      supplier_sku.update_attributes!(params_attributes)
      render_serializer scope: supplier_sku
    end

    private

    def params_attributes
      params.require(:supplier_sku).permit(:supplier_sku_id)
    end

    def supplier_sku
      @supplier_sku ||= SupplierSku.find(params[:id])
    end

    def supplier
      @supplier ||= Supplier.find(params[:supplier_id])
    end

    def sku
      @sku ||= Sku.find(params[:sku_id])
    end

    def index_filters
      param! :sku_name, String, transform: :strip
      param! :supplier_name, String, transform: :strip

      params.permit(:sku_id, :supplier_id, :supplier_sku_id, :sku_name, :supplier_name)
    end

    def valid_create?
      param! :supplier_sku, Hash, required: true, blank: false do |s|
        s.param! :name, String
        s.param! :status, String
        s.param! :metadata, Hash
        s.param! :types, Array
      end
    end

    def valid_update?
      param! :supplier_sku, Hash, required: true, blank: false do |s|
        s.param! :name, String
        s.param! :status, String
        s.param! :metadata, Hash
        s.param! :types, Array
      end
    end
  end
end
