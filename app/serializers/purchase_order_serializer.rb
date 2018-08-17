class PurchaseOrderSerializer < ApplicationSerializer
  attributes :id, :user_id, :supplier_id, :supplier_name, :vendor_id, :code,
             :status, :type, :delivery_date, :created_at, :updated_at

  def supplier_name
    object.supplier.name
  end

  #
  # Default attributes for serializer
  #
  # @return [Array] Array of symbolize attributes
  def self.default_attributes
    [:id, :supplier_id, :supplier_name, :vendor_id, :code, :status, :type, :created_at]
  end
end
