class CreateVendors < ActiveRecord::Migration[5.1]
  def change
    create_table :vendors do |t|
      t.citext :name, null: false
      t.citext :status, index: true
      t.jsonb :metadata
      t.citext :invoice_number_template

      t.datetime :deleted_at
      t.timestamps
    end
  end
end
