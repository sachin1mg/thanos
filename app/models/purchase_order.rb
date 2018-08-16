class PurchaseOrder < ApplicationRecord
  self.inheritance_column = nil

  has_paper_trail
  acts_as_paranoid
  include AASM

  aasm column: 'status' do
    state :created, initial: true
    state :pending
    state :cancelled
    state :closed

    event :cancel do
      transitions from: [:created], to: :cancelled
    end

    event :pending do
      transitions from: [:created], to: :pending
    end

    event :close do
      transitions from: [:created, :pending], to: :closed
    end
  end

  enum type: {
    jit: 'jit',
    bulk: 'bulk'
  }

  # enum status: {
  #   created: 'created',
  #   pending: 'pending',
  #   cancelled: 'cancelled',
  #   closed: 'closed'
  # }

  has_many :purchase_order_items
  has_many :purchase_receipts
  belongs_to :supplier
  belongs_to :vendor
  belongs_to :user

  validates_presence_of :code, :status, :type

  before_validation :init

  def init
    self.status ||= :draft
    self.metadata ||= {}
  end
end
