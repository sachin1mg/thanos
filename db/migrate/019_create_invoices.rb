class CreateInvoices < ActiveRecord::Migration[5.1]
  def change
    create_table :invoices do |t|
      t.belongs_to :sales_order, foreign_key: true
      t.citext :number, index: { unique: true, where: 'deleted_at IS NULL' }
      t.date :date
      t.attachment :attachment
      t.jsonb :metadata

      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
