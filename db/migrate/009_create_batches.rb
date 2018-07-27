class CreateBatches < ActiveRecord::Migration[5.1]
  def change
    create_table :batches do |t|
      t.references :sku, foreign_key: true
      t.decimal :mrp, precision: 8, scale: 2
      t.citext :name
      t.date :manufacturing_date
      t.date :expiry_date
      t.jsonb :metadata

      t.datetime :deleted_at
      t.timestamps
    end
  end
end