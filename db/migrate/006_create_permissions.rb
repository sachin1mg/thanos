class CreatePermissions < ActiveRecord::Migration[5.1]
  def change
    create_table :permissions do |t|
      t.citext :label, index: true, unique: true
      t.citext :status, index: true

      t.timestamps
    end
  end
end
