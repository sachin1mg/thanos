class CreatePurchaseOrderItems < ActiveRecord::Migration[5.1]
  def change
    create_table :purchase_order_items do |t|
      t.references :purchase_order, foreign_key: true
      t.references :material_request_item, foreign_key: true
      t.references :sku, foreign_key: true
      t.integer :quantity
      t.decimal :price, precision: 8, scale: 2
      t.integer :status, index: true
      t.date :schedule_date
      t.jsonb :metadata
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
