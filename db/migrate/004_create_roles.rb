class CreateRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :roles do |t|
      t.citext :label, index: true
      t.integer :parent_id, index: true

      t.timestamps
    end
  end
end
