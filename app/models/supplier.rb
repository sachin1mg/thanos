class Supplier < ApplicationRecord
  has_paper_trail
  acts_as_paranoid

  enum status: {
    active: 'active',
    inactive: 'inactive'
  }

  has_many :vendor_supplier_contracts
  has_many :supplier_skus
  has_many :schemes, as: :schemable
  has_many :purchase_orders
  has_many :purchase_receipts

  validates_presence_of :name, :status, :types

  before_validation :init

  def init
    self.status ||= :active
    self.types ||= []
    self.metadata ||= {}
  end

  def self.search(term)
    where("name like '%#{term}%'")
  end
end
