class CreateRolesUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :roles_users, id: false do |t|
      t.references :user
      t.references :role
    end
    add_index :roles_users, [:user_id, :role_id], unique: true
  end
end
