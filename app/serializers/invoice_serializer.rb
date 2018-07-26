class InvoiceSerializer < ApplicationSerializer
  attributes :id, :sales_order_id, :number, :date, :attachment, :created_at, :updated_at

  def self.default_attributes
    [:id, :sales_order_id, :number, :date, :attachment, :created_at, :updated_at]
  end
end
