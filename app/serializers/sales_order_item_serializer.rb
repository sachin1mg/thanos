class SalesOrderItemSerializer < ApplicationSerializer
  attributes :id, :sku, :batch_and_location, :quantity, :sales_order_id, :price, 
             :discount, :status, :metadata, :deleted_at, :created_at, :updated_at

  def sku
    ActiveModelSerializers::SerializableResource.new(object.sku, fields: [:id, :sku_name, :uom]).as_json
  end

  def batch_and_location
    ActiveModelSerializers::SerializableResource.new(object.batches_and_locations, fields: [:id, :expiry_date, :location]).as_json
  end

  def self.default_attributes
    [:id, :sku_id, :sales_order_id, :price, :quantity, :discount,
     :status, :metadata, :deleted_at, :created_at, :updated_at]
  end
end
