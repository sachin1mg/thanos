class SalesOrderSku < ApplicationRecord
  acts_as_paranoid
  has_paper_trail

  enum status: {
    active: 'active',
    inactive: 'inactive'
  }

  validates_presence_of :price, :status
  validates_numericality_of :price, :discount, greater_than_or_equal_to: 0

  belongs_to :sales_order
  # belongs_to :sku
  has_many :pickups
end
