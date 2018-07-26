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
  belongs_to :supplier, class_name: 'Vendor'

  validates_presence_of :code, :delivery_date, :status

  before_validation :init

  def init
    self.status ||= :draft
    self.metadata ||= {}
  end
end
