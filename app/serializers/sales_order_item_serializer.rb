class SalesOrderItemSerializer < ApplicationSerializer
  attributes :id, :sku, :batch, :sales_order_id, :price, 
             :discount, :status, :metadata, :deleted_at, :created_at, :updated_at

  def sku
    ActiveModelSerializers::SerializableResource.new(object.sku, fields: [:id, :sku_name, :uom]).as_json
  end

  def batch
    ActiveModelSerializers::SerializableResource.new(object.batches, fields: [:id, :expiry_date]).as_json
  end

  def self.default_attributes
    [:id, :sku_id, :sales_order_id, :price, :discount,
     :status, :metadata, :deleted_at, :created_at, :updated_at]
  end
end
