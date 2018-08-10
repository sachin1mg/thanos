class CreateMrPoMappings < ActiveRecord::Migration[5.1]
  def change
    create_table :mr_po_mappings do |t|
      t.references :purchase_order_item, foreign_key: true
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
