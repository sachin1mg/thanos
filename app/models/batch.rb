class Batch < ApplicationRecord
  has_paper_trail
  acts_as_paranoid

  has_many :inventories
  belongs_to :sku

  validates_presence_of :manufacturing_date, :expiry_date
  validates_numericality_of :mrp, greater_than: 0
  validate :valid_expiry_date

  before_validation :init

  def init
    self.metadata ||= {}
  end

  def valid_expiry_date
    return if manufacturing_date.nil? || expiry_date.nil?
    if manufacturing_date > expiry_date
      self.errors.add(:expiry_date, 'Should be greater than manufacturing date')
    end
  end

end
