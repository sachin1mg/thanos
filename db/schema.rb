# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 9) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"

  create_table "permissions", force: :cascade do |t|
    t.citext "label"
    t.citext "status"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_permissions_on_deleted_at"
    t.index ["label"], name: "index_permissions_on_label"
    t.index ["status"], name: "index_permissions_on_status"
  end

  create_table "permissions_roles", id: false, force: :cascade do |t|
    t.bigint "permission_id"
    t.bigint "role_id"
    t.index ["permission_id", "role_id"], name: "index_permissions_roles_on_permission_id_and_role_id", unique: true
    t.index ["permission_id"], name: "index_permissions_roles_on_permission_id"
    t.index ["role_id"], name: "index_permissions_roles_on_role_id"
  end

  create_table "pickups", force: :cascade do |t|
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_pickups_on_deleted_at"
  end

  create_table "roles", force: :cascade do |t|
    t.citext "label"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_roles_on_deleted_at"
    t.index ["label"], name: "index_roles_on_label"
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.bigint "role_id"
    t.bigint "user_id"
    t.index ["role_id", "user_id"], name: "index_roles_users_on_role_id_and_user_id", unique: true
    t.index ["role_id"], name: "index_roles_users_on_role_id"
    t.index ["user_id"], name: "index_roles_users_on_user_id"
  end

  create_table "sales_orders", force: :cascade do |t|
    t.citext "order_reference_id"
    t.decimal "amount", precision: 8, scale: 2
    t.decimal "discount", precision: 8, scale: 2
    t.citext "barcode"
    t.citext "source"
    t.citext "shipping_label_url"
    t.citext "status"
    t.jsonb "metadata"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_sales_orders_on_deleted_at"
    t.index ["order_reference_id"], name: "index_sales_orders_on_order_reference_id"
    t.index ["source"], name: "index_sales_orders_on_source"
    t.index ["status"], name: "index_sales_orders_on_status"
  end

  create_table "users", force: :cascade do |t|
    t.citext "name"
    t.citext "country_code"
    t.citext "phone_number"
    t.citext "email", null: false
    t.citext "encrypted_password", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.citext "item_type", null: false
    t.citext "item_id", null: false
    t.citext "event", null: false
    t.citext "whodunnit"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "permissions_roles", "permissions"
  add_foreign_key "permissions_roles", "roles"
  add_foreign_key "roles_users", "roles"
  add_foreign_key "roles_users", "users"
end
