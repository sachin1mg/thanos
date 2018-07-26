class MaterialRequestSerializer < ApplicationSerializer
  attributes :id, :sales_order_id, :code, :type, :status, :delivery_date, :vendor_id
             :created_at, :updated_at

  #
  # Default attributes for serializer
  #
  # @return [Array] Array of symbolize attributes
  def self.default_attributes
    [:id, :sales_order_id, :code, :type, :status, :delivery_date, :vendor_id, :created_at, :updated_at]
  end
end
