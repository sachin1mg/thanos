class SalesOrderItemSerializer < ApplicationSerializer
  attributes :id, :sku_id, :sales_order_id, :price, 
             :discount, :status, :metadata, :deleted_at, :created_at, :updated_at

  def self.default_attributes
    [:id, :sku_id, :sales_order_id, :price, :discount,
     :status, :metadata, :deleted_at, :created_at, :updated_at]
  end
end
