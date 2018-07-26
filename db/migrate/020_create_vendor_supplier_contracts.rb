class CreateVendorSupplierContracts < ActiveRecord::Migration[5.1]
  def change
    create_table :vendor_supplier_contracts do |t|
      t.references :vendor, foreign_key: true, index: true
      t.references :supplier, index: true, foreign_key: true
      t.citext :status
      t.integer :priority
      t.datetime :deleted_at, index: true

      t.timestamps
    end

    add_index :vendor_supplier_contracts, [:vendor_id, :supplier_id], unique: true
  end
end
