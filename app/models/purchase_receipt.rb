class PurchaseReceipt < ApplicationRecord
  has_paper_trail
  acts_as_paranoid

  enum status: {
    created: 'created',
    pending: 'pending',
    completed: 'completed',
    cancelled: 'cancelled'
  }

  has_many :purchase_receipt_items
  belongs_to :supplier
  belongs_to :vendor
  belongs_to :user

  validates_presence_of :code, :total_amount, :status
  validates_numericality_of :total_amount, greater_than_or_equal_to: 0

  before_validation :init

  def init
    self.status ||= :created
    self.metadata ||= {}
    self.total_amount ||= 0
  end
end
