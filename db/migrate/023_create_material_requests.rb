class CreateMaterialRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :material_requests do |t|
      t.references :user, foreign_key: true
      t.references :vendor, foreign_key: true
      t.references :sku, foreign_key: true
      t.integer :sales_order_item_ids, array: true
      t.integer :quantity
      t.citext :code, index: true
      t.citext :status, index: true
      t.date :schedule_date
      t.date :delivery_date
      t.jsonb :metadata
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
