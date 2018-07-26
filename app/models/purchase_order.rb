class PurchaseOrder < ApplicationRecord
  has_paper_trail
  acts_as_paranoid

  enum status: {
    draft: 'draft',
    pending: 'pending',
    cancelled: 'cancelled',
    closed: 'closed'
  }

  has_many :purchase_order_items
  has_many :purchase_receipts
  belongs_to :supplier

  validates_presence_of :code, :status

  before_validation :init

  def init
    self.status ||= :draft
    self.metadata ||= {}
  end
end
