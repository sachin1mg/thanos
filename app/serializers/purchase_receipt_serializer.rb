class PurchaseReceiptSerializer < ApplicationSerializer
  attributes :id, :supplier_id, :purchase_order_id, :code, :status, :total_amount,
             :vendor_id, :created_at, :updated_at

  #
  # Default attributes for serializer
  #
  # @return [Array] Array of symbolize attributes
  def self.default_attributes
    [:id, :supplier_id, :purchase_order_id, :code, :status, :vendor_id, :total_amount, :created_at, :updated_at]
  end
end
