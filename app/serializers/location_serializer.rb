class LocationSerializer < ApplicationSerializer
  attributes :id, :vendor_id, :aisle, :rack, :slab, :bin, :created_at, :updated_at

  #
  # Default attributes for serializer
  #
  # @return [Array] Array of symbolize attributes
  def self.default_attributes
    [:id, :vendor_id, :aisle, :rack, :slab, :bin, :created_at, :updated_at]
  end
end
