class SalesOrderSerializer < ApplicationSerializer
  attributes :id, :sku_id, :sales_order_id, :customer_name, :price, 
             :discount, :status, :metadata, :deleted_at, :created_at, :updated_at

  def default_attributes
    [:id, :sku_id, :sales_order_id, :customer_name, :price, 
     :discount, :status, :metadata, :deleted_at, :created_at, :updated_at]
  end
end
