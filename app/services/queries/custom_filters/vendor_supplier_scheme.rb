module Queries::CustomFilters
  class VendorSupplierScheme < ::Queries::Filters
    def supplier_id(supplier_id)
      scope.joins(:vendor_supplier_contract).where(vendor_supplier_contracts: { supplier_id: supplier_id })
    end
  end
end
