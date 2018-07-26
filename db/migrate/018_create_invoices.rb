class CreateInvoices < ActiveRecord::Migration[5.1]
  def change
    create_table :invoices do |t|
      t.belongs_to :sales_order, foreign_key: true
      t.citext :number, index: { unique: true }
      t.date :date
      t.attachment :attachment

      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
