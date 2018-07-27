module Queries::CustomFilters
  class VendorSupplierScheme < ::Queries::Filters
    def supplier_id(supplier_id)
      scope.joins(:vendor_supplier_contract).where(vendor_supplier_contracts: { supplier_id: supplier_id })
    end

    def sku_name(sku_name)
      scope.joins(:sku).where("skus.sku_name like ?", "%#{sku_name}%")
    end

    def supplier_name(supplier_name)
      scope.joins(vendor_supplier_contract: :supplier).where("suppliers.name like ?", "%#{supplier_name}%")
    end

    def scheme_name(scheme_name)
      scope.joins(:scheme).where("schemes.name like ?", "%#{scheme_name}%")
    end
  end
end
