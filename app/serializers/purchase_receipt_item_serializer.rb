class PurchaseReceiptItemSerializer < ApplicationSerializer
  attributes :id, :purchase_receipt_id, :purchase_order_item_id, :sku_id, :batch_id,
             :received_quantity, :returned_quantity, :price, :status, :schedule_date,
             :created_at, :updated_at

  #
  # Default attributes for serializer
  #
  # @return [Array] Array of symbolize attributes
  def self.default_attributes
    [:id, :purchase_receipt_id, :purchase_order_item_id, :sku_id, :batch_id,
     :received_quantity, :returned_quantity, :price, :status, :schedule_date,
     :created_at, :updated_at]
  end
end
