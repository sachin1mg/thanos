module InventoryModule
  class SkuManager

    def initialize(sku)
      self.sku = sku
    end

    def create
      save
    end

    def update(params)
      sku.assign_attributes(params)
      save
    end

    def save
      sku.save!
      sku
    end

    private

    attr_accessor :sku
  end
end
