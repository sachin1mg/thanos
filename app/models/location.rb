class Location < ApplicationRecord
  has_paper_trail
  acts_as_paranoid

  belongs_to :vendor
  has_many :inventories

  before_validation :init

  def init
    self.metadata ||= {}
  end

  def to_s
    "#{aisle}-#{rack}-#{slab}-#{bin}"
  end
end
