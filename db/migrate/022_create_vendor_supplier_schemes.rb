class CreateVendorSupplierSchemes < ActiveRecord::Migration[5.1]
  def change
    create_table :vendor_supplier_schemes do |t|
      t.references :vendor_supplier_contract, foreign_key: true, index: true
      t.references :sku, foreign_key: true, index: true
      t.references :scheme, foreign_key: true, index: true
      t.citext :status
      t.datetime :expiry_at, index: true
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
