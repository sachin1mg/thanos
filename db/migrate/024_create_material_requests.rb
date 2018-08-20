class CreateMaterialRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :material_requests do |t|
      t.references :user
      t.references :vendor
      t.references :sku
      t.integer :quantity
      t.citext :status, index: true
      t.jsonb :metadata

      t.datetime :downloaded_at
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
