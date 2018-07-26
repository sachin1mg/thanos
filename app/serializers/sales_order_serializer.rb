class SalesOrderSerializer < ApplicationSerializer
  attributes :id, :vendor_id, :order_reference_id, :customer_name, :amount, 
             :discount, :barcode, :source, :shipping_label_url, :status,
             :metadata, :deleted_at, :created_at, :updated_at

  def self.default_attributes
    [:id, :vendor_id, :order_reference_id, :customer_name, :amount,
     :discount, :barcode, :source, :shipping_label_url, :status,
     :metadata, :deleted_at, :created_at, :updated_at]
  end
end
