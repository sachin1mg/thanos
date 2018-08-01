class Sku < ApplicationRecord
  has_paper_trail
  acts_as_paranoid

  enum uom: {
    number: 'number',
    ml: 'ml'
  }

  # Inventory Module
  has_many :supplier_skus
  has_many :inventories
  has_many :vendor_supplier_schemes
  has_many :batches

  # Order Module
  has_many :sales_order_items
  has_many :material_request_items

  # Procurement Module
  has_many :purchase_order_items
  has_many :purchase_receipt_items

  validates_presence_of :sku_name, :manufacturer_name, :item_group, :uom, :pack_size, :onemg_sku_id
  validates_numericality_of :pack_size, greater_than: 0

  before_validation :init

  def init
    self.metadata ||= {}
  end
end
