class CreateMaterialRequestItems < ActiveRecord::Migration[5.1]
  def change
    create_table :material_request_items do |t|
      t.references :material_request, foreign_key: true
      t.references :sku, foreign_key: true
      t.integer :quantity
      t.citext :status, index: true
      t.date :schedule_date
      t.jsonb :metadata
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
