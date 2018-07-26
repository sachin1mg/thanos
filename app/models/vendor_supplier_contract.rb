class VendorSupplierContract < ApplicationRecord
  acts_as_paranoid
  has_paper_trail

  enum status: {
    active: 'active',
    inactive: 'inactive'
  }

  belongs_to :vendor
  belongs_to :supplier, class_name: 'Vendor', foreign_key: 'supplier_id'

  before_validation :init

  def init
    self.status ||= :active
  end
end
