class MaterialRequest < ApplicationRecord
  has_paper_trail
  acts_as_paranoid

  enum status: {
    created: 'created',
    pending: 'pending',
    ordered: 'ordered',
    partially_ordered: 'partially_ordered',
    cancelled: 'cancelled',
    closed: 'closed'
  }

  validates_presence_of :user, :vendor, :sku, :quantity, :status
  validates_numericality_of :quantity, greater_than_or_equal_to: 0

  belongs_to :user
  belongs_to :vendor
  belongs_to :sku
  has_many :purchase_order_items
  has_many :soi_mr_mappings
  has_many :sales_order_items, through: :soi_mr_mappings

  before_validation :init

  def init
    self.quantity ||= 0
    self.status ||= :created
    self.metadata ||= {}
  end
end
