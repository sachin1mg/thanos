class CreatePurchaseOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :purchase_orders do |t|
      t.references :supplier, foreign_key: true
      t.citext :material_request_ids, array: true
      t.citext :code
      t.citext :status, index: true
      t.date :delivery_date
      t.date :schedule_date
      t.jsonb :metadata
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
