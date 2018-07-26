class CreateSkus < ActiveRecord::Migration[5.1]
  def change
    create_table :skus do |t|
      t.citext :sku_name, null: false
      t.citext :manufacturer_name, null: false
      t.citext :item_group
      t.text :uom
      t.integer :pack_size

      t.datetime :deleted_at
      t.timestamps
    end
  end
end
