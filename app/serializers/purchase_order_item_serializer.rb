class PurchaseOrderItemSerializer < ApplicationSerializer
  attributes :id, :purchase_order_id, :sku_id, :supplier_name,
             :quantity, :price, :status,:schedule_date, :created_at, :updated_at

  def supplier_name
    object.purchase_order.supplier.name
  end

  #
  # Default attributes for serializer
  #
  # @return [Array] Array of symbolize attributes
  def self.default_attributes
    [:id, :purchase_order_id, :sku_id, :quantity, :supplier_name,
     :price, :status,:schedule_date, :created_at, :updated_at]
  end
end
