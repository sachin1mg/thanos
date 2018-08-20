class CreateBatches < ActiveRecord::Migration[5.1]
  def change
    create_table :batches do |t|
      t.references :sku
      t.decimal :mrp, precision: 8, scale: 2
      t.citext :code
      t.citext :name
      t.date :manufacturing_date
      t.date :expiry_date
      t.jsonb :metadata

      t.datetime :deleted_at
      t.timestamps
    end

    add_index :batches,
              [:sku_id, :code],
              unique: true,
              name: 'index_batches_on_sku_id_code'
  end
end