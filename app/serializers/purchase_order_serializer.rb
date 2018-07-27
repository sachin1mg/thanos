class PurchaseOrderSerializer < ApplicationSerializer
  attributes :id, :supplier_id, :material_request_ids, :code, :status, :vendor_id,
             :delivery_date, :schedule_date, :created_at, :updated_at

  #
  # Default attributes for serializer
  #
  # @return [Array] Array of symbolize attributes
  def self.default_attributes
    [:id, :supplier_id, :material_request_ids, :code, :status, :delivery_date,
     :schedule_date, :vendor_id, :created_at, :updated_at]
  end
end
