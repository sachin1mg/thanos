module InventoryModule
  class LocationManager

    def initialize(location)
      self.location = location
    end

    def self.create(params)
      location = Location.new(params)
      self.new(location).save
    end

    def update(params)
      location.assign_attributes(params)
      save
    end

    #
    # Save inventory and publish inventory update event.
    #
    def save
      location.save!
      location
    end

    private

    attr_accessor :location
  end
end
