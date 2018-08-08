class MaterialRequest < ApplicationRecord
  has_paper_trail
  acts_as_paranoid

  enum status: {
    created: 'created',
    downloaded: 'downloaded',
    ordered: 'ordered',
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
    self.sales_order_item_ids ||= []
  end

  def generate_code
    Time.now.to_i.to_s
  end
end
