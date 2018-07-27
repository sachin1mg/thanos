class VendorSupplierSchemeSerializer < ApplicationSerializer
  attributes :id, :vendor_supplier_contract_id, :scheme_id, :status, :expiry_at, :updated_at, :created_at,
             :deleted_at, :sku, :supplier, :scheme

  def sku
    ActiveModelSerializers::SerializableResource.new(object.sku, fields: [:id, :sku_name]).as_json
  end

  def supplier
    ActiveModelSerializers::SerializableResource.new(object.supplier, fields: [:id, :name]).as_json
  end

  def scheme
    ActiveModelSerializers::SerializableResource.new(
      object.scheme,
      fields: [:id, :name, :discount_type, :discount_units, :min_amount, :min_amount_type]
    ).as_json
  end

  #
  # Default attributes for serializer
  #
  # @return [Array] Array of symbolize attributes
  #
  def self.default_attributes
    [:id, :vendor_supplier_contract_id, :sku_id, :scheme_id, :status, :expiry_at, :updated_at, :created_at, :deleted_at]
  end
end
