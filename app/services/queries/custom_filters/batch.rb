module Queries::CustomFilters
  class Batch < ::Queries::Filters
    def sku_name(sku_name)
      scope.joins(:sku).where("skus.sku_name like ?", "%#{sku_name}%")
    end

    def manufacturer_name(manufacturer_name)
      scope.joins(:sku).where("skus.manufacturer_name like ?", "%#{manufacturer_name}%")
    end
  end
end
