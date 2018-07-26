class PurchaseReceiptItem < ApplicationRecord
  has_paper_trail
  acts_as_paranoid

  enum status: {
    draft: 'draft',
    pending: 'pending',
    completed: 'completed',
    cancelled: 'cancelled'
  }

  belongs_to :purchase_order_item
  belongs_to :purchase_receipt
  belongs_to :sku
  belongs_to :batch

  validates_presence_of :received_quantity, :returned_quantity, :price, :status
  validates_numericality_of :received_quantity, greater_than_or_equal_to: 0
  validates_numericality_of :returned_quantity, greater_than_or_equal_to: 0
  validates_numericality_of :price, greater_than_or_equal_to: 0

  before_validation :init

  def init
    self.status ||= :draft
    self.metadata ||= {}
    self.received_quantity ||= 0
    self.returned_quantity ||= 0
    self.price ||= 0
  end
end
