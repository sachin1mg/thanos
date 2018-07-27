class InventorySerializer < ApplicationSerializer
  attributes :id, :vendor_id, :sku_id, :batch_id, :location_id, :quantity,
    :cost_price, :selling_price, :created_at, :updated_at, :location, :sku

  def location
    ActiveModelSerializers::SerializableResource.new(object.location).as_json
  end

  def sku
    ActiveModelSerializers::SerializableResource.new(object.sku).as_json
  end

  #
  # Default attributes for serializer
  #
  # @return [Array] Array of symbolize attributes
  def self.default_attributes
    [:id, :vendor_id, :sku_id, :batch_id, :location_id, :quantity,
      :cost_price, :selling_price, :created_at, :updated_at]
  end
end


