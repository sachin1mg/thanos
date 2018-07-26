class Vendor < ApplicationRecord
  has_paper_trail
  acts_as_paranoid

  enum status: {
    active: 'active',
    inactive: 'inactive'
  }

  has_many :locations
  has_many :inventories
  has_many :sales_orders
  has_many :vendor_supplier_contracts
  has_many :purchase_orders
  has_many :purchase_receipts
  has_many :material_requests
  has_many :purchase_receipt_items, through: :purchase_receipts
  has_many :material_request_items, through: :material_requests
  has_many :purchase_order_items, through: :purchase_orders

  validates_presence_of :name, :status, :invoice_number_template

  before_validation :init

  def init
    self.metadata ||= {}
  end
end
