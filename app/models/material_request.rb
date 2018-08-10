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

  belongs_to :user
  belongs_to :sku
  belongs_to :vendor
  has_many :purchase_order_items

  validates_presence_of :code, :status

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
