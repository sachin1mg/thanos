class Pickup < ApplicationRecord
  acts_as_paranoid
  has_paper_trail

  # belongs_to :inventory
  # belongs_to :sales_order_sku
end
