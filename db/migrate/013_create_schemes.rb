class CreateSchemes < ActiveRecord::Migration[5.1]
  def change
    create_table :schemes do |t|
      t.belongs_to :vendor
      t.citext :vendor_type
      t.citext :name
      t.citext :discount_type
      t.float :discount_units
      t.citext :min_amount_type
      t.float :min_amount
      t.citext :status, index: true
      t.datetime :expiry_at, index: true
      t.datetime :deleted_at, index: true

      t.timestamps
    end

    add_index :schemes, [:name, :vendor_id, :vendor_type], unique: true, where: 'deleted_at is null'
  end
end