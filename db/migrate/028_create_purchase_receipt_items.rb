class CreatePurchaseReceiptItems < ActiveRecord::Migration[5.1]
  def change
    create_table :purchase_receipt_items do |t|
      t.references :purchase_receipt
      t.references :purchase_order_item
      t.references :sku
      t.references :batch
      t.integer :received_quantity
      t.integer :returned_quantity
      t.decimal :price, precision: 8, scale: 2
      t.citext :status, index: true
      t.date :schedule_date
      t.jsonb :metadata
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
