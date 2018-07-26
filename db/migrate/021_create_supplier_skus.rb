class CreateSupplierSkus < ActiveRecord::Migration[5.1]
  def change
    create_table :supplier_skus do |t|
      t.belongs_to :supplier
      t.belongs_to :sku
      t.citext :supplier_sku_id
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :supplier_skus, [:supplier_id, :sku_id], unique: true, where: 'deleted_at is null'
  end
end
