class VendorSupplierScheme < ApplicationRecord
  acts_as_paranoid
  has_paper_trail

  enum status: {
    active: 'active',
    inactive: 'inactive'
  }

  belongs_to :vendor_supplier_contract
  belongs_to :sku
  belongs_to :scheme

  before_validation :init

  def init
    self.status ||= :active
  end

  def supplier
    self.vendor_supplier_contract.supplier
  end
end
