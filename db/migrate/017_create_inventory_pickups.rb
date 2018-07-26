class CreateInventoryPickups < ActiveRecord::Migration[5.1]
  def change
    create_table :inventory_pickups do |t|
      t.belongs_to :sales_order_item, foreign_key: true
      # t.belongs_to :inventory, foreign_key: true
      t.jsonb :metadata

      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
