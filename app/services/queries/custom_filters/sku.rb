module Queries::CustomFilters
  class Sku < ::Queries::Filters
    def sku_name_filter(sku_name)
      scope.where("sku_name like ?", "%#{sku_name}%")
    end

    def manufacturer_name_filter(manufacturer_name)
      scope.where("manufacturer_name like ?", "%#{manufacturer_name}%")
    end

    def item_group_filter(item_group)
      scope.where("item_group like ?", "%#{item_group}%")
    end

    def onemg_sku_id_filter(onemg_sku_id)
      scope.where("onemg_sku_id like ?", "%#{onemg_sku_id}%")
    end
  end
end
