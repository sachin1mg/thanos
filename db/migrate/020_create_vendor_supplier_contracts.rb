class CreateVendorSupplierContracts < ActiveRecord::Migration[5.1]
  def change
    create_table :vendor_supplier_contracts do |t|
      t.belongs_to :vendor
      t.belongs_to :supplier
      t.citext :status, index: true
      t.integer :priority
      t.datetime :deleted_at, index: true

      t.timestamps
    end

    add_index :vendor_supplier_contracts, [:vendor_id, :supplier_id], unique: true, where: 'deleted_at is null'
  end
end
