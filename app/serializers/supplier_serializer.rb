class SupplierSerializer < ApplicationSerializer
  attributes :id, :name, :status, :types, :metadata, :created_at

  #
  # Default attributes for serializer
  #
  # @return [Array] Array of symbolize attributes
  #
  def self.default_attributes
    [:id, :name, :status, :types, :metadata, :created_at]
  end
end
