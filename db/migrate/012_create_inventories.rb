class CreateInventories < ActiveRecord::Migration[5.1]
  def change
    create_table :inventories do |t|
      t.references :location, foreign_key: true
      t.references :vendor, foreign_key: true
      t.references :sku, foreign_key: true
      t.references :batch, foreign_key: true
      t.integer :quantity
      t.decimal :cost_price, precision: 8, scale: 2
      t.decimal :selling_price, precision: 8, scale: 2
      t.jsonb :metadata

      t.datetime :deleted_at
      t.timestamps
    end
  end
end
