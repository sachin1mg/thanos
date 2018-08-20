class CreateInventoryPickups < ActiveRecord::Migration[5.1]
  def change
    create_table :inventory_pickups do |t|
      t.references :sales_order_item
      t.references :inventory
      t.citext :status
      t.integer :quantity
      t.jsonb :metadata

      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
