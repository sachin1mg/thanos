class Invoice < ApplicationRecord
  INVOICE_NUMBER_LENGTH = 16

  acts_as_paranoid
  has_paper_trail

  has_attached_file :attachment,
                    path: "/upload/invoices/:id/original-:hash.:extension",
                    hash_secret: 'Invoice'

  validates_attachment :attachment, content_type: { content_type: [/\Aimage\/.*\Z/, /\A.*pdf\Z/] }

  belongs_to :sales_order

  after_create :set_number

  private

  #
  # Set invoice number
  #
  def set_number
    self.number = invoice_number
    self.save!
  end

  #
  # Invoice number length should be fixed. If length < INVOICE_NUMBER_LENGTH, then we insert zeros in between
  # @return [String] Invoice number
  #
  def invoice_number
    date = self.created_at.to_date

    # Eg: 'LT171803'
    prefix = "LT#{date.current_financial_year}#{format('%02d', date.month)}"
    postfix = self.id.to_s
    prefix + postfix.rjust(INVOICE_NUMBER_LENGTH - prefix.length, '0')
  end
end
