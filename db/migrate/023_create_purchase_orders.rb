class CreatePurchaseOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :purchase_orders do |t|
      t.references :user
      t.references :supplier
      t.references :vendor
      t.citext :code
      t.citext :type
      t.citext :status, index: true
      t.date :delivery_date
      t.jsonb :metadata
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
