class CreatePermissionsRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :permissions_roles, id: false do |t|
      t.references :permission, foreign_key: true
      t.references :role, foreign_key: true
    end
    add_index :permissions_roles, [:permission_id, :role_id], unique: true
  end
end
