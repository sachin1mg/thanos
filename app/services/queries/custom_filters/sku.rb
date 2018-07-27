module Queries::CustomFilters
  class Sku < ::Queries::Filters
    def sku_name_filter(sku_name)
      scope.joins(:sku).where("sku_name like ?", "%#{sku_name.downcase}%")
    end

    def manufacturer_name_filter(manufacturer_name)
      scope.where("manufacturer_name like ?", "%#{manufacturer_name.downcase}%")
    end

    def item_group_filter(item_group)
      scope.where("item_group like ?", "%#{item_group.downcase}%")
    end

    def onemg_sku_id_filter(onemg_sku_id)
      scope.where("onemg_sku_id like ?", "%#{onemg_sku_id.downcase}%")
    end
  end
end
