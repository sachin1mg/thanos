class Vendor < ApplicationRecord
  has_paper_trail
  acts_as_paranoid

  has_many :locations
  has_many :inventories
  has_many :sales_orders

  validates_presence_of :name, :status, :types, :invoice_number_template

  before_validation :init

  def init
    self.metadata ||= {}
  end
end
