class SupplierSku < ApplicationRecord
  acts_as_paranoid
  has_paper_trail

  belongs_to :supplier
  belongs_to :sku

  validates_presence_of :supplier_sku_id
end
