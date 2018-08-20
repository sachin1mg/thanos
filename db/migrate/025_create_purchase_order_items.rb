class CreatePurchaseOrderItems < ActiveRecord::Migration[5.1]
  def change
    create_table :purchase_order_items do |t|
      t.references :material_request
      t.references :purchase_order
      t.references :sku
      t.integer :quantity
      t.decimal :price, precision: 8, scale: 2
      t.citext :status, index: true
      t.date :schedule_date
      t.jsonb :metadata

      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
