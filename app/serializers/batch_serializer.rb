class BatchSerializer < ApplicationSerializer
  attributes :id, :sku_id, :mrp, :manufacturing_date, :expiry_date,
             :created_at, :updated_at

  #
  # Default attributes for serializer
  #
  # @return [Array] Array of symbolize attributes
  def self.default_attributes
    [:id, :sku_id, :mrp, :manufacturing_date, :expiry_date, :created_at, :updated_at]
  end
end
