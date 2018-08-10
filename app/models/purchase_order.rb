class PurchaseOrder < ApplicationRecord
  has_paper_trail
  acts_as_paranoid

  enum po_type: {
    jit: 'jit',
    bulk: 'bulk'
  }

  enum status: {
    draft: 'draft',
    pending: 'pending',
    cancelled: 'cancelled',
    closed: 'closed'
  }

  has_many :purchase_order_items
  has_many :purchase_receipts
  belongs_to :supplier
  belongs_to :vendor
  belongs_to :user

  validates_presence_of :code, :status, :po_type

  before_validation :init

  def init
    self.status ||= :draft
    self.metadata ||= {}
  end
end
