class SupplierSkuSerializer < ApplicationSerializer
  attributes :id, :supplier_sku_id, :created_at, :updated_at, :deleted_at, :sku, :supplier

  def sku
    ActiveModelSerializers::SerializableResource.new(object.sku, fields: [:id, :sku_name]).as_json
  end

  def supplier
    ActiveModelSerializers::SerializableResource.new(object.supplier, fields: [:id, :name]).as_json
  end

  #
  # Default attributes for serializer
  #
  # @return [Array] Array of symbolize attributes
  #
  def self.default_attributes
    [:id, :supplier_id, :sku_id, :supplier_sku_id, :created_at, :updated_at, :deleted_at]
  end
end
