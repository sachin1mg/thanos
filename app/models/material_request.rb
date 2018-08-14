class MaterialRequest < ApplicationRecord
  has_paper_trail
  acts_as_paranoid

  enum status: {
    draft: 'draft',
    pending: 'pending',
    ordered: 'ordered',
    partially_ordered: 'partially_ordered',
    cancelled: 'cancelled'
  }

  validates_presence_of :user, :vendor, :sku, :quantity, :status
  validates_numericality_of :quantity, greater_than_or_equal_to: 0

  belongs_to :user
  belongs_to :vendor
  belongs_to :sku
  belongs_to :purchase_order_item, optional: true
  has_many :soi_mr_mappings
  has_many :sales_order_items, through: :soi_mr_mappings

  before_validation :init

  def init
    self.quantity ||= 0
    self.status ||= :draft
    self.metadata ||= {}
  end
end
