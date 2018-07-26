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

    add_index :vendor_supplier_schemes,
              [:vendor_supplier_contract_id, :sku_id, :scheme_id],
              unique: true,
              where: 'deleted_at is null',
              name: 'unique_vendor_supplier_contract_id_sku_id_scheme_id'
  end
end
