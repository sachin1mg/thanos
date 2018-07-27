module Queries::CustomFilters
  class SupplierSku < ::Queries::Filters
    def sku_name(sku_name)
      scope.joins(:sku).where("sku_name like ?", "%#{sku_name.downcase}%")
    end

    def supplier_name(name)
      scope.joins(:supplier).where("name like ?", "%#{name.downcase}%")
    end
  end
end
