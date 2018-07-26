class MaterialRequestItem < ApplicationRecord
  has_paper_trail
  acts_as_paranoid

  enum status: {
    draft: 'draft',
    pending: 'pending',
    ordered: 'ordered',
    partially_ordered: 'partially_ordered',
    cancelled: 'cancelled'
  }

  belongs_to :material_request
  belongs_to :sku
  has_many :purchase_order_items

  validates_presence_of :quantity, :status
  validates_numericality_of :quantity, greater_than_or_equal_to: 0

  before_validation :init

  def init
    self.metadata ||= {}
    self.quantity ||= 0
    self.status ||= :draft
  end
end
