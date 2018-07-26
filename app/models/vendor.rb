class Vendor < ApplicationRecord
  has_paper_trail
  acts_as_paranoid

  has_many :locations
  has_many :inventories

  validates_presence_of :name, :status, :types, :invoice_number_template
end
