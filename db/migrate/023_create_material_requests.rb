class CreateMaterialRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :material_requests do |t|
      t.references :sales_order, foreign_key: true
      t.citext :code, index: true
      t.citext :type, index: true
      t.integer :status, index: true
      t.date :delivery_date
      t.jsonb :metadata
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
