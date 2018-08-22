class PurchaseReceiptSerializer < ApplicationSerializer
  attributes :id, :supplier_id, :code, :status, :total_amount,
             :supplier_name, :vendor_id, :created_at, :updated_at

  def supplier_name
    object.supplier.name
  end

  #
  # Default attributes for serializer
  #
  # @return [Array] Array of symbolize attributes
  def self.default_attributes
    [:id, :supplier_id, :supplier_name, :code, :status,
     :vendor_id, :total_amount, :created_at, :updated_at]
  end
end
