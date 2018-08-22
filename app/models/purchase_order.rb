class PurchaseOrder < ApplicationRecord
  self.inheritance_column = nil

  include StateTransitions::PurchaseOrder

  has_paper_trail
  acts_as_paranoid

  enum type: {
    jit: 'jit',
    bulk: 'bulk'
  }

  enum status: {
    created: 'created',
    pending: 'pending',
    cancelled: 'cancelled',
    closed: 'closed'
  }

  has_many :purchase_order_items
  has_many :purchase_receipts
  belongs_to :supplier
  belongs_to :vendor
  belongs_to :user

  validates_presence_of :code, :status, :type

  before_validation :init

  def init
    self.status ||= :draft
    self.metadata ||= {}
    self.code = 'random' #TODO change code
  end
end
