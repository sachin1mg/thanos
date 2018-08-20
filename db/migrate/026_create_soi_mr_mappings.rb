class CreateSoiMrMappings < ActiveRecord::Migration[5.1]
  def change
    create_table :soi_mr_mappings do |t|
      t.references :sales_order_item
      t.references :material_request
      t.integer :quantity

      t.datetime :deleted_at, index: true
      t.timestamps
    end

    add_index :soi_mr_mappings,
              [:sales_order_item_id, :material_request_id],
              unique: true,
              name: 'index_on_sales_order_item_id_and_material_request_id'
  end
end
