class MaterialRequestSerializer < ApplicationSerializer
  attributes :id, :user_id, :vendor_id, :sku_id, :purchase_order_item_id, :quantity, :status, 
             :downloaded_at, :created_at, :updated_at

  #
  # Default attributes for serializer
  #
  # @return [Array] Array of symbolize attributes
  def self.default_attributes
    [:id, :user_id, :vendor_id, :sku_id, :purchase_order_item_id, :quantity, :status, 
    :downloaded_at, :created_at, :updated_at]
  end
end
