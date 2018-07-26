class CreateLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :locations do |t|
      t.references :vendor, foreign_key: true
      t.citext :aisle
      t.citext :rack
      t.citext :slab
      t.citext :bin
      t.jsonb :meta_data

      t.datetime :deleted_at
      t.timestamps
    end
  end
end
