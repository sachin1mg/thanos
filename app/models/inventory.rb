class Inventory < ApplicationRecord
  has_paper_trail
  acts_as_paranoid

  belongs_to :location
  belongs_to :vendor
  belongs_to :sku
  belongs_to :batch

  validates_presence_of :quantity, :cost_price, :selling_price
  validates_numericality_of :quantity, greater_than_or_equal_to: 0
  validates_numericality_of :cost_price, greater_than: 0
  validates_numericality_of :selling_price, greater_than: 0

  before_validation :init

  def init
    self.metadata ||= {}
  end
end
