class CreatePickups < ActiveRecord::Migration[5.1]
  def change
    create_table :pickups do |t|
      t.belongs_to :sales_order_sku, foreign_key: true
      # t.belongs_to :inventory, foreign_key: true

      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
