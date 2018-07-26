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

ActiveRecord::Schema.define(version: 12) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"

  create_table "batches", force: :cascade do |t|
    t.bigint "sku_id"
    t.decimal "mrp", precision: 8, scale: 2
    t.date "manufacturing_date"
    t.date "expiry_date"
    t.jsonb "metadata"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sku_id"], name: "index_batches_on_sku_id"
  end

  create_table "inventories", force: :cascade do |t|
    t.bigint "vendor_id"
    t.bigint "sku_id"
    t.bigint "batch_id"
    t.bigint "location_id"
    t.integer "quantity"
    t.decimal "cost_price", precision: 8, scale: 2
    t.decimal "selling_price", precision: 8, scale: 2
    t.jsonb "metadata"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["batch_id"], name: "index_inventories_on_batch_id"
    t.index ["location_id"], name: "index_inventories_on_location_id"
    t.index ["sku_id"], name: "index_inventories_on_sku_id"
    t.index ["vendor_id", "sku_id", "batch_id", "location_id"], name: "index_inventories_on_vendor_id_sku_id_batch_id_and_location_id", unique: true, where: "(deleted_at IS NULL)"
    t.index ["vendor_id"], name: "index_inventories_on_vendor_id"
  end

  create_table "locations", force: :cascade do |t|
    t.bigint "vendor_id"
    t.citext "aisle"
    t.citext "rack"
    t.citext "slab"
    t.citext "bin"
    t.jsonb "metadata"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["vendor_id"], name: "index_locations_on_vendor_id"
  end

  create_table "permissions", force: :cascade do |t|
    t.citext "label"
    t.citext "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "roles", force: :cascade do |t|
    t.citext "label"
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["label"], name: "index_roles_on_label"
    t.index ["parent_id"], name: "index_roles_on_parent_id"
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.bigint "role_id"
    t.bigint "user_id"
    t.index ["role_id", "user_id"], name: "index_roles_users_on_role_id_and_user_id", unique: true
    t.index ["role_id"], name: "index_roles_users_on_role_id"
    t.index ["user_id"], name: "index_roles_users_on_user_id"
  end

  create_table "skus", force: :cascade do |t|
    t.citext "sku_name", null: false
    t.citext "manufacturer_name", null: false
    t.citext "item_group"
    t.citext "uom"
    t.integer "pack_size"
    t.jsonb "metadata"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.citext "name"
    t.citext "email", default: "", null: false
    t.citext "encrypted_password", default: "", null: false
    t.citext "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vendors", force: :cascade do |t|
    t.citext "name", null: false
    t.citext "status"
    t.citext "types", array: true
    t.jsonb "metadata"
    t.citext "invoice_number_template"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_vendors_on_status"
    t.index ["types"], name: "index_vendors_on_types", using: :gin
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

  add_foreign_key "batches", "skus"
  add_foreign_key "inventories", "batches"
  add_foreign_key "inventories", "locations"
  add_foreign_key "inventories", "skus"
  add_foreign_key "inventories", "vendors"
  add_foreign_key "locations", "vendors"
  add_foreign_key "permissions_roles", "permissions"
  add_foreign_key "permissions_roles", "roles"
  add_foreign_key "roles_users", "roles"
  add_foreign_key "roles_users", "users"
end
