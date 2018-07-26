class PurchaseOrderItemSerializer < ApplicationSerializer
  attributes :id, :purchase_order_id, :material_request_item_id, :sku_id,
             :quantity, :price, :status,:schedule_date, :created_at, :updated_at

  #
  # Default attributes for serializer
  #
  # @return [Array] Array of symbolize attributes
  def self.default_attributes
    [:id, :purchase_order_id, :material_request_item_id, :sku_id, :quantity,
     :price, :status,:schedule_date, :created_at, :updated_at]
  end
end
