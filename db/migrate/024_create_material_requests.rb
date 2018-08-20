class CreateMaterialRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :material_requests do |t|
      t.references :user, foreign_key: true
      t.references :vendor, foreign_key: true
      t.references :sku, foreign_key: true
      t.integer :quantity
      t.citext :status, index: true
      t.jsonb :metadata

      t.datetime :downloaded_at
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
