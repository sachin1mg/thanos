module Queries::CustomFilters
  class Inventory < ::Queries::Filters

    def sku_name(sku_name)
      Rails.logger.info("#########################")
      Rails.logger.info(sku_name)
      Rails.logger.info(scope.count)
      scope.joins(:sku).where("sku_name like ?", "%#{sku_name.downcase}%")
    end

    def manufacturer_name(manufacturer_name)
      scope.joins(:sku).where("manufacturer_name like ?", "%#{manufacturer_name.downcase}%")
    end
  end
end
