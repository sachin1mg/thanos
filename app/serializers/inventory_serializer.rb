class InventorySerializer < ApplicationSerializer
  attributes :id, :vendor_id, :sku_id, :batch_id, :location_id, :quantity,
    :cost_price, :selling_price, :created_at, :updated_at

  #
  # Default attributes for serializer
  #
  # @return [Array] Array of symbolize attributes
  def self.default_attributes
    [:id, :vendor_id, :sku_id, :batch_id, :location_id, :quantity,
      :cost_price, :selling_price, :created_at, :updated_at]
  end
end


