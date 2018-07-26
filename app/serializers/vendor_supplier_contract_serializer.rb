class VendorSupplierContractSerializer < ApplicationSerializer
  attributes :id, :vendor_id, :supplier_id, :status, :priority, :updated_at, :created_at, :deleted_at

  #
  # Default attributes for serializer
  #
  # @return [Array] Array of symbolize attributes
  #
  def self.default_attributes
    [:id, :vendor_id, :supplier_id, :status, :priority, :updated_at, :created_at, :deleted_at]
  end
end
