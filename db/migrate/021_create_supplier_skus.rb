class CreateSupplierSkus < ActiveRecord::Migration[5.1]
  def change
    create_table :supplier_skus do |t|
      t.references :supplier, index: true, foreign_key: { to_table: :vendors }
      t.references :sku, foreign_key: true, index: true
      t.citext :supplier_sku_id
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :supplier_skus, [:supplier_id, :sku_id], unique: true
  end
end
