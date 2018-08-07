class PurchaseOrderItem < ApplicationRecord
  has_paper_trail
  acts_as_paranoid

  enum status: {
    draft: 'draft',
    pending: 'pending',
    cancelled: 'cancelled',
    closed: 'closed'
  }

  belongs_to :sku
  belongs_to :material_request, optional: true
  belongs_to :purchase_order
  has_many :purchase_receipt_items

  validates_presence_of :price, :quantity, :status
  validates_numericality_of :quantity, greater_than_or_equal_to: 0
  validates_numericality_of :price, greater_than_or_equal_to: 0

  before_validation :init

  def init
    self.status ||= :draft
    self.metadata ||= {}
    self.quantity ||= 0
    self.price ||= 0
  end
end
