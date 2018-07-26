module Api::Public::V1
  class VendorSupplierContractsController < BaseController
    skip_before_action :valid_action?, only: [:index, :show]

    def index
      render_serializer scope: vendor_supplier_contracts
    end

    def show
      render_serializer scope: vendor_supplier_contract
    end

    def create
      vendor_supplier_contract = vendor_supplier_contracts.create!(params_attributes.merge(supplier: supplier))
      render_serializer scope: vendor_supplier_contract
    end

    def update
      vendor_supplier_contract.update_attributes!(params_attributes)
      render_serializer scope: vendor_supplier_contract
    end

    private

    def params_attributes
      params.require(:vendor_supplier_contract).permit(:status, :priority)
    end

    def valid_create?
      param! :vendor_id, Integer
      param! :supplier_id, Integer

      param! :vendor_supplier_contract, Hash, required: true, blank: false do |s|
        s.param! :status, String
        s.param! :priority, Integer
      end
    end

    def valid_update?
      param! :vendor_id, Integer
      param! :supplier_id, Integer

      param! :vendor_supplier_contract, Hash, required: true, blank: false do |s|
        s.param! :status, String
        s.param! :priority, Integer
      end
    end

    def supplier
      @supplier ||= Supplier.find(params[:supplier_id])
    end

    def vendor_supplier_contracts
      @vendor_supplier_contracts ||= current_vendor.vendor_supplier_contracts
    end

    def vendor_supplier_contract
      vendor_supplier_contracts.find(params[:id])
    end
  end
end
