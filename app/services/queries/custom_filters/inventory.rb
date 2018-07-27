module Queries::CustomFilters
  class Inventory < ::Queries::Filters
    def sku_name(sku_name)
      scope.joins(:sku).where("sku_name like ?", "%#{sku_name}%")
    end
  end
end
