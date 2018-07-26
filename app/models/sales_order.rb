class SalesOrder < ApplicationRecord
  acts_as_paranoid
  has_paper_trail

  enum status: {
    active: 'active',
    inactive: 'inactive'
  }

  validates_presence_of :amount, :status
  validates_numericality_of :amount, :discount, greater_than_or_equal_to: 0

  # belongs_to :vendor
end
