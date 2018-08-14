class CreateSoiMrMappings < ActiveRecord::Migration[5.1]
  def change
    create_table :soi_mr_mappings do |t|
      t.references :sales_order_item, foreign_key: true
      t.references :material_request, foreign_key: true
      t.integer :quantity

      t.datetime :deleted_at, index: true
      t.timestamps
    end

    add_index :soi_mr_mappings,
              [:sales_order_item_id, :material_request_id],
              unique: true,
              name: 'index_on_sales_order_item_id_and_material_request_id',
              where: 'deleted_at IS NULL'
  end
end
