class Batch < ApplicationRecord
  has_paper_trail
  acts_as_paranoid

  has_many :inventories
  has_many :purchase_receipt_items
  belongs_to :sku

  validates_presence_of :manufacturing_date, :expiry_date
  validates_numericality_of :mrp, greater_than: 0

  before_validation :init

  validate :valid_expiry_date

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
