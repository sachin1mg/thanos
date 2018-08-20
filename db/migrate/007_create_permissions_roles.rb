class CreatePermissionsRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :permissions_roles, id: false do |t|
      t.references :role
      t.references :permission
    end
    add_index :permissions_roles, [:role_id, :permission_id], unique: true
  end
end
