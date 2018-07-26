module InventoryModule
  class InventoryManager

    def initialize(inventory)
      self.inventory = inventory
    end

    def self.create(params)
      self.new(Inventory.new(params)).save
    end

    def update(params)
      inventory.assign_attributes(params)
      save
    end

    def save
      inventory.save!
      inventory
    end

    private

    attr_accessor :inventory
  end
end
