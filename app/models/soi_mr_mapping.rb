class SoiMrMapping < ApplicationRecord
  acts_as_paranoid
  has_paper_trail

  validates_presence_of :sales_order_item, :material_request, :quantity
  validates_numericality_of :quantity, greater_than_or_equal_to: 0
  validates :sales_order_item, uniqueness: { scope: :material_request }

  belongs_to :sales_order_item
  belongs_to :material_request
end
