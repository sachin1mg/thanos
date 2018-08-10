class Invoice < ApplicationRecord
  acts_as_paranoid
  has_paper_trail

  has_attached_file :attachment,
                    path: "/upload/invoices/:id/original-:hash.:extension",
                    hash_secret: 'Invoice'

  validates_attachment :attachment, content_type: { content_type: [/\Aimage\/.*\Z/, /\A.*pdf\Z/] }
  validates_presence_of :number, :date, :attachment, :sales_order

  belongs_to :sales_order

  before_validation :init
  after_create :set_number
  
  def init
    self.metadata ||= {}
  end

  private

  #
  # Set invoice number
  #
  def set_number
    #TODO from vendor
  end
end
