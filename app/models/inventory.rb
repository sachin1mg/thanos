class Inventory < ApplicationRecord
  has_paper_trail
  acts_as_paranoid

  belongs_to :location
  belongs_to :vendor
  belongs_to :sku
  belongs_to :batch
  has_many :inventory_pickups

  validates_presence_of :quantity, :mrp
  validates_numericality_of :quantity, greater_than_or_equal_to: 0
  validates_numericality_of :mrp, greater_than: 0

  before_validation :init

  def init
    self.metadata ||= {}
  end
end
