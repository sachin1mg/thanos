class MaterialRequestSerializer < ApplicationSerializer
  attributes :id, :sku_id, :quantity, :status, :created_at

  has_one :sku

  #
  # Default attributes for serializer
  #
  # @return [Array] Array of symbolize attributes
  def self.default_attributes
    [:id, :sku_id, :quantity, :status, :created_at]
  end
end
