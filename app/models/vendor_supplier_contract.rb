class VendorSupplierContract < ApplicationRecord
  acts_as_paranoid
  has_paper_trail

  enum status: {
    active: 'active',
    inactive: 'inactive'
  }

  belongs_to :vendor
  belongs_to :supplier

  has_many :vendor_supplier_schemes

  before_validation :init

  def init
    self.status ||= :active
  end
end
