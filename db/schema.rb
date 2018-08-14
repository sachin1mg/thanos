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

ActiveRecord::Schema.define(version: 28) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"

  create_table "batches", force: :cascade do |t|
    t.bigint "sku_id"
    t.decimal "mrp", precision: 8, scale: 2
    t.citext "code"
    t.date "manufacturing_date"
    t.date "expiry_date"
    t.jsonb "metadata"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sku_id", "code"], name: "index_batches_on_sku_id_code", unique: true, where: "(deleted_at IS NULL)"
    t.index ["sku_id"], name: "index_batches_on_sku_id"
  end

  create_table "inventories", force: :cascade do |t|
    t.bigint "vendor_id"
    t.bigint "sku_id"
    t.bigint "batch_id"
    t.bigint "location_id"
    t.integer "quantity"
    t.integer "blocked_quantity"
    t.integer "reserved_quantity"
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

  create_table "inventory_pickups", force: :cascade do |t|
    t.bigint "sales_order_item_id"
    t.bigint "inventory_id"
    t.citext "status"
    t.integer "quantity"
    t.jsonb "metadata"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_inventory_pickups_on_deleted_at"
    t.index ["inventory_id"], name: "index_inventory_pickups_on_inventory_id"
    t.index ["sales_order_item_id"], name: "index_inventory_pickups_on_sales_order_item_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.bigint "sales_order_id"
    t.citext "number"
    t.date "date"
    t.string "attachment_file_name"
    t.string "attachment_content_type"
    t.integer "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.jsonb "metadata"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_invoices_on_deleted_at"
    t.index ["number"], name: "index_invoices_on_number", unique: true, where: "(deleted_at IS NULL)"
    t.index ["sales_order_id"], name: "index_invoices_on_sales_order_id"
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

  create_table "material_requests", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "vendor_id"
    t.bigint "sku_id"
    t.bigint "purchase_order_item_id"
    t.integer "quantity"
    t.citext "status"
    t.jsonb "metadata"
    t.datetime "downloaded_at"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_material_requests_on_deleted_at"
    t.index ["purchase_order_item_id"], name: "index_material_requests_on_purchase_order_item_id"
    t.index ["sku_id"], name: "index_material_requests_on_sku_id"
    t.index ["status"], name: "index_material_requests_on_status"
    t.index ["user_id"], name: "index_material_requests_on_user_id"
    t.index ["vendor_id"], name: "index_material_requests_on_vendor_id"
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
    t.bigint "role_id"
    t.bigint "permission_id"
    t.index ["permission_id"], name: "index_permissions_roles_on_permission_id"
    t.index ["role_id", "permission_id"], name: "index_permissions_roles_on_role_id_and_permission_id", unique: true
    t.index ["role_id"], name: "index_permissions_roles_on_role_id"
  end

  create_table "purchase_order_items", force: :cascade do |t|
    t.bigint "purchase_order_id"
    t.bigint "sku_id"
    t.integer "quantity"
    t.decimal "price", precision: 8, scale: 2
    t.citext "status"
    t.date "schedule_date"
    t.jsonb "metadata"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_purchase_order_items_on_deleted_at"
    t.index ["purchase_order_id"], name: "index_purchase_order_items_on_purchase_order_id"
    t.index ["sku_id"], name: "index_purchase_order_items_on_sku_id"
    t.index ["status"], name: "index_purchase_order_items_on_status"
  end

  create_table "purchase_orders", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "supplier_id"
    t.bigint "vendor_id"
    t.citext "code"
    t.citext "type"
    t.citext "status"
    t.date "delivery_date"
    t.jsonb "metadata"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_purchase_orders_on_deleted_at"
    t.index ["status"], name: "index_purchase_orders_on_status"
    t.index ["supplier_id"], name: "index_purchase_orders_on_supplier_id"
    t.index ["user_id"], name: "index_purchase_orders_on_user_id"
    t.index ["vendor_id"], name: "index_purchase_orders_on_vendor_id"
  end

  create_table "purchase_receipt_items", force: :cascade do |t|
    t.bigint "purchase_receipt_id"
    t.bigint "purchase_order_item_id"
    t.bigint "sku_id"
    t.bigint "batch_id"
    t.integer "received_quantity"
    t.integer "returned_quantity"
    t.decimal "price", precision: 8, scale: 2
    t.citext "status"
    t.date "schedule_date"
    t.jsonb "metadata"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["batch_id"], name: "index_purchase_receipt_items_on_batch_id"
    t.index ["deleted_at"], name: "index_purchase_receipt_items_on_deleted_at"
    t.index ["purchase_order_item_id"], name: "index_purchase_receipt_items_on_purchase_order_item_id"
    t.index ["purchase_receipt_id"], name: "index_purchase_receipt_items_on_purchase_receipt_id"
    t.index ["sku_id"], name: "index_purchase_receipt_items_on_sku_id"
    t.index ["status"], name: "index_purchase_receipt_items_on_status"
  end

  create_table "purchase_receipts", force: :cascade do |t|
    t.bigint "supplier_id"
    t.bigint "purchase_order_id"
    t.bigint "vendor_id"
    t.citext "code"
    t.citext "status"
    t.decimal "total_amount", precision: 8, scale: 2
    t.jsonb "metadata"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_purchase_receipts_on_deleted_at"
    t.index ["purchase_order_id"], name: "index_purchase_receipts_on_purchase_order_id"
    t.index ["status"], name: "index_purchase_receipts_on_status"
    t.index ["supplier_id"], name: "index_purchase_receipts_on_supplier_id"
    t.index ["vendor_id"], name: "index_purchase_receipts_on_vendor_id"
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
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_roles_users_on_role_id"
    t.index ["user_id", "role_id"], name: "index_roles_users_on_user_id_and_role_id", unique: true
    t.index ["user_id"], name: "index_roles_users_on_user_id"
  end

  create_table "sales_order_items", force: :cascade do |t|
    t.bigint "sku_id"
    t.bigint "sales_order_id"
    t.decimal "price", precision: 8, scale: 2
    t.decimal "discount", precision: 8, scale: 2
    t.citext "status"
    t.integer "quantity"
    t.jsonb "metadata"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_sales_order_items_on_deleted_at"
    t.index ["sales_order_id"], name: "index_sales_order_items_on_sales_order_id"
    t.index ["sku_id"], name: "index_sales_order_items_on_sku_id"
    t.index ["status"], name: "index_sales_order_items_on_status"
  end

  create_table "sales_orders", force: :cascade do |t|
    t.bigint "vendor_id"
    t.citext "order_reference_id"
    t.citext "customer_name"
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
    t.index ["customer_name"], name: "index_sales_orders_on_customer_name"
    t.index ["deleted_at"], name: "index_sales_orders_on_deleted_at"
    t.index ["order_reference_id"], name: "index_sales_orders_on_order_reference_id"
    t.index ["source"], name: "index_sales_orders_on_source"
    t.index ["status"], name: "index_sales_orders_on_status"
    t.index ["vendor_id"], name: "index_sales_orders_on_vendor_id"
  end

  create_table "schemes", force: :cascade do |t|
    t.string "schemable_type"
    t.bigint "schemable_id"
    t.citext "name"
    t.citext "discount_type"
    t.float "discount_units"
    t.citext "min_amount_type"
    t.float "min_amount"
    t.citext "status"
    t.datetime "expiry_at"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_schemes_on_deleted_at"
    t.index ["expiry_at"], name: "index_schemes_on_expiry_at"
    t.index ["name", "schemable_id", "schemable_type"], name: "index_schemes_on_name_and_schemable_id_and_schemable_type", unique: true, where: "(deleted_at IS NULL)"
    t.index ["schemable_type", "schemable_id"], name: "index_schemes_on_schemable_type_and_schemable_id"
    t.index ["status"], name: "index_schemes_on_status"
  end

  create_table "skus", force: :cascade do |t|
    t.citext "sku_name", null: false
    t.citext "manufacturer_name", null: false
    t.citext "item_group"
    t.citext "uom"
    t.citext "onemg_sku_id"
    t.integer "pack_size"
    t.jsonb "metadata"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "soi_mr_mappings", force: :cascade do |t|
    t.bigint "sales_order_item_id"
    t.bigint "material_request_id"
    t.integer "quantity"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_soi_mr_mappings_on_deleted_at"
    t.index ["material_request_id"], name: "index_soi_mr_mappings_on_material_request_id"
    t.index ["sales_order_item_id", "material_request_id"], name: "index_on_sales_order_item_id_and_material_request_id", unique: true, where: "(deleted_at IS NULL)"
    t.index ["sales_order_item_id"], name: "index_soi_mr_mappings_on_sales_order_item_id"
  end

  create_table "supplier_skus", force: :cascade do |t|
    t.bigint "supplier_id"
    t.bigint "sku_id"
    t.citext "supplier_sku_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sku_id"], name: "index_supplier_skus_on_sku_id"
    t.index ["supplier_id", "sku_id"], name: "index_supplier_skus_on_supplier_id_and_sku_id", unique: true, where: "(deleted_at IS NULL)"
    t.index ["supplier_id"], name: "index_supplier_skus_on_supplier_id"
  end

  create_table "suppliers", force: :cascade do |t|
    t.citext "name", null: false
    t.citext "status"
    t.citext "types", array: true
    t.jsonb "metadata"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_suppliers_on_deleted_at"
    t.index ["status"], name: "index_suppliers_on_status"
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
    t.bigint "vendor_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["vendor_id"], name: "index_users_on_vendor_id"
  end

  create_table "vendor_supplier_contracts", force: :cascade do |t|
    t.bigint "vendor_id"
    t.bigint "supplier_id"
    t.citext "status"
    t.integer "priority"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_vendor_supplier_contracts_on_deleted_at"
    t.index ["status"], name: "index_vendor_supplier_contracts_on_status"
    t.index ["supplier_id"], name: "index_vendor_supplier_contracts_on_supplier_id"
    t.index ["vendor_id", "supplier_id"], name: "index_vendor_supplier_contracts_on_vendor_id_and_supplier_id", unique: true, where: "(deleted_at IS NULL)"
    t.index ["vendor_id"], name: "index_vendor_supplier_contracts_on_vendor_id"
  end

  create_table "vendor_supplier_schemes", force: :cascade do |t|
    t.bigint "vendor_supplier_contract_id"
    t.bigint "sku_id"
    t.bigint "scheme_id"
    t.citext "status"
    t.datetime "expiry_at"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_vendor_supplier_schemes_on_deleted_at"
    t.index ["expiry_at"], name: "index_vendor_supplier_schemes_on_expiry_at"
    t.index ["scheme_id"], name: "index_vendor_supplier_schemes_on_scheme_id"
    t.index ["sku_id"], name: "index_vendor_supplier_schemes_on_sku_id"
    t.index ["status"], name: "index_vendor_supplier_schemes_on_status"
    t.index ["vendor_supplier_contract_id", "sku_id", "scheme_id"], name: "unique_vendor_supplier_contract_id_sku_id_scheme_id", unique: true, where: "(deleted_at IS NULL)"
    t.index ["vendor_supplier_contract_id"], name: "index_vendor_supplier_schemes_on_vendor_supplier_contract_id"
  end

  create_table "vendors", force: :cascade do |t|
    t.citext "name", null: false
    t.citext "status"
    t.jsonb "metadata"
    t.citext "invoice_number_template"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_vendors_on_status"
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
  add_foreign_key "inventory_pickups", "inventories"
  add_foreign_key "inventory_pickups", "sales_order_items"
  add_foreign_key "invoices", "sales_orders"
  add_foreign_key "locations", "vendors"
  add_foreign_key "material_requests", "purchase_order_items"
  add_foreign_key "material_requests", "skus"
  add_foreign_key "material_requests", "users"
  add_foreign_key "material_requests", "vendors"
  add_foreign_key "permissions_roles", "permissions"
  add_foreign_key "permissions_roles", "roles"
  add_foreign_key "purchase_order_items", "purchase_orders"
  add_foreign_key "purchase_order_items", "skus"
  add_foreign_key "purchase_orders", "suppliers"
  add_foreign_key "purchase_orders", "users"
  add_foreign_key "purchase_orders", "vendors"
  add_foreign_key "purchase_receipt_items", "batches"
  add_foreign_key "purchase_receipt_items", "purchase_order_items"
  add_foreign_key "purchase_receipt_items", "purchase_receipts"
  add_foreign_key "purchase_receipt_items", "skus"
  add_foreign_key "purchase_receipts", "purchase_orders"
  add_foreign_key "purchase_receipts", "suppliers"
  add_foreign_key "purchase_receipts", "vendors"
  add_foreign_key "roles_users", "roles"
  add_foreign_key "roles_users", "users"
  add_foreign_key "sales_order_items", "sales_orders"
  add_foreign_key "sales_order_items", "skus"
  add_foreign_key "sales_orders", "vendors"
  add_foreign_key "soi_mr_mappings", "material_requests"
  add_foreign_key "soi_mr_mappings", "sales_order_items"
end
