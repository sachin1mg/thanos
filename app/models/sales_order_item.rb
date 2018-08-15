class SalesOrderItem < ApplicationRecord
  acts_as_paranoid
  has_paper_trail

  enum status: {
    draft: 'draft',
    to_be_processed: 'to_be_processed',
    processed: 'processed'
  }

  validates_presence_of :price, :status
  validates_numericality_of :price, :discount, :quantity, greater_than_or_equal_to: 0

  belongs_to :sales_order
  belongs_to :sku
  has_many :inventory_pickups
  has_many :soi_mr_mappings
  has_many :material_requests, through: :soi_mr_mappings

  before_validation :init

  def init
    self.status ||= :draft
    self.price ||= 0
    self.discount ||= 0
    self.metadata ||= {}
  end

  def batches_and_locations
    self.inventory_pickups.map do |inventory_pickup|
      { 
        id: inventory_pickup.inventory.batch_id,
        name: inventory_pickup.inventory.batch.name,
        expiry_date: inventory_pickup.inventory.batch.expiry_date,
        location: inventory_pickup.inventory.location.to_s,
        quantity: inventory_pickup.quantity
      }
    end
  end
end
