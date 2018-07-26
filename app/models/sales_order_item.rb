class SalesOrderItem < ApplicationRecord
  acts_as_paranoid
  has_paper_trail

  enum status: {
    active: 'active',
    inactive: 'inactive'
  }

  validates_presence_of :price, :status
  validates_numericality_of :price, :discount, greater_than_or_equal_to: 0

  belongs_to :sales_order
  belongs_to :sku
  has_many :inventory_pickups

  before_validation :init

  def init
    self.status ||= :active
    self.price ||= 0
    self.discount ||= 0
    self.metadata ||= {}
  end
end
