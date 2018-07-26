class CreateVendorSupplierSchemes < ActiveRecord::Migration[5.1]
  def change
    create_table :vendor_supplier_schemes do |t|
      t.belongs_to :vendor_supplier_contract
      t.belongs_to :sku
      t.belongs_to :scheme
      t.citext :status, index: true
      t.datetime :expiry_at, index: true
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
