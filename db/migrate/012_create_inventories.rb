class CreateInventories < ActiveRecord::Migration[5.1]
  def change
    create_table :inventories do |t|
      t.references :vendor
      t.references :sku
      t.references :batch
      t.references :location
      t.integer :quantity
      t.integer :blocked_quantity
      t.integer :reserved_quantity
      t.decimal :cost_price, precision: 8, scale: 2
      t.decimal :selling_price, precision: 8, scale: 2
      t.jsonb :metadata

      t.datetime :deleted_at
      t.timestamps
    end

    add_index :inventories,
              [:vendor_id, :sku_id, :batch_id, :location_id],
              unique: true,
              name: 'index_inventories_on_vendor_id_sku_id_batch_id_and_location_id'
  end
end
