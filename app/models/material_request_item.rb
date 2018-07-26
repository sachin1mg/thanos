class MaterialRequestItem < ApplicationRecord
  has_paper_trail
  acts_as_paranoid

  belongs_to :material_request
  belongs_to :sku
  has_many :purchase_order_items

  validates_presence_of :quantity, :schedule_date
  validates_numericality_of :quantity, greater_than_or_equal_to: 0

  before_validation :init

  def init
    self.metadata ||= {}
  end
end
