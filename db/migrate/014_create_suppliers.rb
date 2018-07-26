class CreateSuppliers < ActiveRecord::Migration[5.1]
  def change
    create_table :suppliers do |t|
      t.citext :name, null: false
      t.citext :status, index: true
      t.citext :types, array: true
      t.jsonb :metadata

      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
