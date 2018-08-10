class SalesOrder < ApplicationRecord
  acts_as_paranoid
  has_paper_trail

  enum status: {
    draft: 'draft',
    to_be_processed: 'to_be_processed',
    processed: 'processed'
  }

  validates_presence_of :amount, :status
  validates_numericality_of :amount, :discount, greater_than_or_equal_to: 0

  belongs_to :vendor
  has_many :sales_order_items
  has_many :inventory_pickups, through: :sales_order_items
  has_many :invoices

  before_validation :init

  def init
    self.status ||= :draft
    self.amount ||= 0
    self.discount ||= 0
    self.metadata ||= {}
  end
end
