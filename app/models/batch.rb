class Batch < ApplicationRecord
  has_paper_trail
  acts_as_paranoid

  has_many :inventories
  belongs_to :sku

  validates_presence_of :manufacturing_date, :expiry_date
end
