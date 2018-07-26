class SupplierSerializer < ApplicationSerializer
  attributes :id, :name, :status, :types, :metadata, :created_at, :updated_at, :deleted_at

  #
  # Default attributes for serializer
  #
  # @return [Array] Array of symbolize attributes
  #
  def default_attributes
    [:id, :name, :status, :types, :metadata, :created_at, :updated_at, :deleted_at]
  end
end
