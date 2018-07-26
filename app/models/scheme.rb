class Scheme < ApplicationRecord
  acts_as_paranoid
  has_paper_trail

  enum status: {
    active: 'active',
    inactive: 'inactive'
  }

  validates_presence_of :vendor_type, :discount_type, :discount_units
  validates_numericality_of :discount_units, greater_than_or_equal_to: 0
  validates :name, uniqueness: { scope: [:vendor_id, :vendor_type] }

  belongs_to :vendor

  before_validation :init

  def init
    self.status ||= :active
  end
end
