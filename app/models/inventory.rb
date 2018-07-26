class Inventory < ApplicationRecord
  has_paper_trail
  acts_as_paranoid

  belongs_to :location
  belongs_to :vendor
  belongs_to :sku
  belongs_to :batch

  validates_presence_of :quantity, :mrp
end
