module Api::Public::V1
  class VendorSupplierSchemesController < ::Api::Public::AuthController
    skip_before_action :valid_action?, only: [:index, :show]

    def index
      render_serializer scope: vendor_supplier_schemes.filter(filter_params)
    end

    def show
      render_serializer scope: vendor_supplier_scheme
    end

    def create
      vendor_supplier_scheme = vendor_supplier_contract.vendor_supplier_schemes.create!(params_attributes.merge(sku: sku, scheme: scheme))
      render_serializer scope: vendor_supplier_scheme
    end

    def update
      vendor_supplier_scheme.update_attributes!(params_attributes)
      render_serializer scope: vendor_supplier_scheme
    end

    private

    def params_attributes
      params.require(:vendor_supplier_scheme).permit(:status, :expiry_at)
    end

    def vendor_supplier_scheme
      @vendor_supplier_scheme ||= vendor_supplier_schemes.find(params[:id])
    end

    def vendor_supplier_schemes
      @vendor_supplier_schemes ||= current_vendor.vendor_supplier_schemes
    end

    def vendor_supplier_contract
      current_vendor.vendor_supplier_contracts.find_by(supplier_id: params[:supplier_id], status: :active)
    end

    def sku
      @sku ||= Sku.find(params[:sku_id])
    end

    def scheme
      @scheme ||= Scheme.find(params[:scheme_id])
    end

    def filter_params
      param! :scheme_name, String, transform: :strip
      param! :sku_name, String, transform: :strip
      param! :supplier_name, String, transform: :strip

      params.permit(:sku_id, :supplier_id, :supplier_name, :sku_name, :scheme_name)
    end

    def valid_create?
      param! :vendor_supplier_scheme, Hash, required: true, blank: false do |s|
        s.param! :name, String
        s.param! :status, String
        s.param! :metadata, Hash
        s.param! :types, Array
      end
    end

    def valid_update?
      param! :vendor_supplier_scheme, Hash, required: true, blank: false do |s|
        s.param! :name, String
        s.param! :status, String
        s.param! :metadata, Hash
        s.param! :types, Array
      end
    end
  end
end
