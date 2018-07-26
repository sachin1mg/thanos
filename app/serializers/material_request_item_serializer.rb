class MaterialRequestItemSerializer < ApplicationSerializer
  attributes :id, :material_request_id, :sku_id, :quantity, :status,
             :schedule_date, :created_at, :updated_at

  #
  # Default attributes for serializer
  #
  # @return [Array] Array of symbolize attributes
  def self.default_attributes
    [:id, :material_request_id, :sku_id, :quantity, :status, :schedule_date, :created_at, :updated_at]
  end
end
