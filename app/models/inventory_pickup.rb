class InventoryPickup < ApplicationRecord
  acts_as_paranoid
  has_paper_trail

  enum status: {
    pending: 'pending',
    ready: 'ready',
    closed: 'closed'
  }

  belongs_to :inventory
  belongs_to :sales_order_item

  validates_numericality_of :quantity, greater_than_or_equal_to: 0

  before_validation :init
  
  def init
    self.status = :pending
    self.metadata ||= {}
  end
end
