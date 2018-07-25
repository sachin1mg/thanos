class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.citext :name
      t.citext :country_code
      t.citext :phone_number
      t.citext :email, null: false, index: { unique: true }
      t.citext :encrypted_password, null: false
      t.datetime :deleted_at, index: true

      t.timestamps null: false
    end
  end
end
