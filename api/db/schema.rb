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

ActiveRecord::Schema.define(version: 2019_08_21_104723) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.string "name", null: false
    t.string "pid", null: false
    t.string "unit", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "gtin", null: false
    t.index ["gtin", "pid"], name: "index_articles_on_gtin_and_pid", unique: true
    t.index ["pid"], name: "index_articles_on_pid", unique: true
  end

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "inventories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inventory_articles", force: :cascade do |t|
    t.bigint "inventory_id"
    t.bigint "article_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "count", default: 0, null: false
    t.index ["article_id"], name: "index_inventory_articles_on_article_id"
    t.index ["inventory_id"], name: "index_inventory_articles_on_inventory_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "count", default: 1, null: false
    t.bigint "product_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "inventory_id"
    t.bigint "article_id"
    t.integer "status", default: 0, null: false
    t.index ["article_id"], name: "index_orders_on_article_id"
    t.index ["inventory_id"], name: "index_orders_on_inventory_id"
    t.index ["product_id"], name: "index_orders_on_product_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "gtin", null: false
    t.string "lot", null: false
    t.datetime "manufacture_date", null: false
    t.datetime "expiry_date", null: false
    t.datetime "used_at"
    t.bigint "article_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "inventory_id"
    t.index ["article_id"], name: "index_products_on_article_id"
    t.index ["gtin"], name: "index_products_on_gtin"
    t.index ["inventory_id"], name: "index_products_on_inventory_id"
    t.index ["lot"], name: "index_products_on_lot"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "access_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "inventory_id"
    t.integer "role", default: 0, null: false
    t.index ["access_token"], name: "index_users_on_access_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["inventory_id"], name: "index_users_on_inventory_id"
  end

  add_foreign_key "inventory_articles", "articles"
  add_foreign_key "inventory_articles", "inventories"
  add_foreign_key "orders", "articles"
  add_foreign_key "orders", "inventories"
  add_foreign_key "orders", "products"
  add_foreign_key "orders", "users"
  add_foreign_key "products", "articles"
  add_foreign_key "products", "inventories"
  add_foreign_key "users", "inventories"
end
