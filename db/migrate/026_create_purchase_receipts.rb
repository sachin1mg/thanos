class CreatePurchaseReceipts < ActiveRecord::Migration[5.1]
  def change
    create_table :purchase_receipts do |t|
      t.references :supplier, foreign_key: true
      t.references :purchase_order, foreign_key: true
      t.citext :code
      t.citext :status, index: true
      t.decimal :total_amount, precision: 8, scale: 2
      t.jsonb :metadata
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
