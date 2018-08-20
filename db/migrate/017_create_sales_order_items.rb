class CreateSalesOrderItems < ActiveRecord::Migration[5.1]
  def change
    create_table :sales_order_items do |t|
      t.references :sku
      t.references :sales_order
      t.decimal :price, precision: 8, scale: 2
      t.decimal :discount, precision: 8, scale: 2
      t.citext :status, index: true
      t.integer :quantity
      t.jsonb :metadata

      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
