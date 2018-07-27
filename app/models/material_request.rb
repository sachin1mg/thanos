class MaterialRequest < ApplicationRecord
  self.inheritance_column = nil

  has_paper_trail
  acts_as_paranoid

  enum type: {
    jit: 'jit',
    bulk: 'bulk'
  }

  enum status: {
    draft: 'draft',
    pending: 'pending',
    ordered: 'ordered',
    partially_ordered: 'partially_ordered',
    cancelled: 'cancelled'
  }

  belongs_to :sales_order
  has_many :material_request_items
  belongs_to :vendor

  validates_presence_of :code, :status

  before_validation :init

  def init
    self.status ||= :draft
    self.metadata ||= {}
  end
end
