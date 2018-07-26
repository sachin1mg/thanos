class Sku < ApplicationRecord
  has_paper_trail
  acts_as_paranoid

  enum uom: [:number, :ml]

  has_many :inventories
  has_many :batches

  validates_presence_of :sku_name, :manufacturer_name, :item_group, :uom, :pack_size
end
