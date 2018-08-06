class Adjustment < ApplicationRecord
  has_paper_trail
  acts_as_paranoid

  belongs_to :inventory

  validates_presence_of :reason
  validates_numericality_of :quantity_changed, greater_than_or_equal_to: 0

  before_validation :init

  def init
    self.metadata ||= {}
  end
end
