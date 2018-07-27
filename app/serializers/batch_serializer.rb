class BatchSerializer < ApplicationSerializer
  attributes :id, :sku, :mrp, :manufacturing_date, :expiry_date, :name, :created_at, :updated_at

  def sku
    ActiveModelSerializers::SerializableResource.new(object.sku, fields: [:id, :sku_name, :manufacturer_name]).as_json
  end

  #
  # Default attributes for serializer
  #
  # @return [Array] Array of symbolize attributes
  def self.default_attributes
    [:id, :sku_id, :mrp, :manufacturing_date, :expiry_date, :name, :created_at, :updated_at]
  end
end
