class Scheme < ApplicationRecord
  acts_as_paranoid
  has_paper_trail

  enum status: {
    active: 'active',
    inactive: 'inactive'
  }

  validates_presence_of :discount_type, :discount_units
  validates_numericality_of :discount_units, greater_than_or_equal_to: 0
  validates :name, uniqueness: { scope: [:schemable_id, :schemable_type] }

  belongs_to :schemable, polymorphic: true

  before_validation :init

  def init
    self.status ||= :active
  end
end
