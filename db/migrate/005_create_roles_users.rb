class CreateRolesUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :roles_users, id: false do |t|
      t.references :role, foreign_key: true
      t.references :user, foreign_key: true
    end
    add_index :roles_users, [:role_id, :user_id], unique: true
  end
end
