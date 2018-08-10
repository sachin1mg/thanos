class PurchaseOrderSerializer < ApplicationSerializer
  attributes :id, :supplier_id, :po_type, :code, :status, :vendor_id,
             :delivery_date, :created_at, :updated_at

  #
  # Default attributes for serializer
  #
  # @return [Array] Array of symbolize attributes
  def self.default_attributes
    [:id, :supplier_id, :code, :po_type, :status, :delivery_date,
    :vendor_id, :created_at, :updated_at]
  end
end
