class CreateSalesOrderItems < ActiveRecord::Migration[5.1]
  def change
    create_table :sales_order_items do |t|
      t.belongs_to :sku, foreign_key: true
      t.belongs_to :sales_order, foreign_key: true
      t.decimal :price, precision: 8, scale: 2
      t.decimal :discount, precision: 8, scale: 2
      t.citext :status, index: true
      t.jsonb :metadata

      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
