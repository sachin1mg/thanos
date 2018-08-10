class MrPoMapping < ApplicationRecord
  has_paper_trail
  acts_as_paranoid

  belongs_to :purchase_order_item, optional: true
  has_many :material_requests
end
