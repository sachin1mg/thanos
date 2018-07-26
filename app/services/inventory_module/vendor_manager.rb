module InventoryModule
  class VendorManager

    def initialize(vendor)
      self.vendor = vendor
    end

    def create
      save
    end

    def update(params)
      vendor.assign_attributes(params)
      save
    end

    def save
      vendor.save!
      vendor
    end

    private

    attr_accessor :vendor
  end
end
