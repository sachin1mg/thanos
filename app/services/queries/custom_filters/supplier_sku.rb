module Queries::CustomFilters
  class SupplierSku < ::Queries::Filters
    def sku_name(sku_name)
      scope.joins(:sku).where("skus.sku_name like ?", "%#{sku_name}%")
    end

    def supplier_name(name)
      scope.joins(:supplier).where("suppliers.name like ?", "%#{name}%")
    end
  end
end
