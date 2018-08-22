class CreatePurchaseReceipts < ActiveRecord::Migration[5.1]
  def change
    create_table :purchase_receipts do |t|
      t.references :supplier
      t.references :user
      t.references :vendor
      t.citext :code
      t.citext :status, index: true
      t.decimal :total_amount, precision: 8, scale: 2
      t.jsonb :metadata
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
