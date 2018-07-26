module InventoryModule
  class BatchManager

    def initialize(batch)
      self.batch = batch
    end

    def self.create(params)
      save
    end

    def update(params)
      batch.assign_attributes(params)
      save
    end

    def save
      batch.save!
      batch
    end

    private

    attr_accessor :batch
  end
end
