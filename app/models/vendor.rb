class Vendor < ApplicationRecord
  TYPES = %w[seller supplier].freeze

  has_paper_trail
  acts_as_paranoid

  enum status: {
    active: 'active',
    inactive: 'inactive'
  }

  has_many :locations
  has_many :inventories
  has_many :sales_orders

  validates_presence_of :name, :status, :types, :invoice_number_template

  before_validation :init

  validate :valid_types

  def init
    self.types ||= []
    self.metadata ||= {}
  end

  def valid_types
    extra_types = self.types - TYPES
    self.errors.add(:types, "contain in values - #{extra_types.join(', ')}") if extra_types.present?
  end
end
