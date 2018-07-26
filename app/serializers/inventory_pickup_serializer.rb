class InventoryPickupSerializer < ApplicationSerializer
  attributes :id, :sales_order_item_id, :inventory_id, :metadata, 
             :created_at, :updated_at

  #
  # Default attributes for serializer
  #
  # @return [Array] Array of symbolize attributes
  def self.default_attributes
    [:id, :sales_order_item_id, :inventory_id, :metadata, 
     :created_at, :updated_at]
  end
end


