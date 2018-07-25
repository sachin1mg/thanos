class CreateSalesOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :sales_orders do |t|
      # t.belongs_to :vendor, foreign_key: true
      t.citext :order_reference_id, index: true
      t.decimal :amount, precision: 8, scale: 2
      t.decimal :discount, precision: 8, scale: 2
      t.citext :barcode
      t.citext :source, index: true
      t.citext :shipping_label_url
      t.citext :status, index: true
      t.jsonb :metadata

      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
