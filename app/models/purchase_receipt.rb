class PurchaseReceipt < ApplicationRecord
  has_paper_trail
  acts_as_paranoid

  enum status: {
    draft: 'draft',
    pending: 'pending',
    completed: 'completed',
    cancelled: 'cancelled'
  }

  has_many :purchase_receipt_items
  belongs_to :purchase_order
  belongs_to :supplier

  validates_presence_of :code, :total_amount, :status
  validates_numericality_of :total_amount, greater_than_or_equal_to: 0

  before_validation :init

  def init
    self.status ||= :draft
    self.metadata ||= {}
  end
end
