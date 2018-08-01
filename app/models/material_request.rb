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

  belongs_to :sales_order, optional: true
  belongs_to :vendor
  has_many :material_request_items

  validates_presence_of :code, :status, :type

  before_validation :init

  def init
    self.status ||= :draft
    self.code ||= generate_code
    self.metadata ||= {}
  end

  def generate_code
    Time.now.to_i.to_s
  end
end
