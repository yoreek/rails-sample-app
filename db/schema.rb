# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20161111171853) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.string "email"
  end

  create_table "charges", force: :cascade do |t|
    t.decimal "amount",          precision: 10, scale: 2
    t.integer "status"
    t.date    "operate_from"
    t.date    "operate_to"
    t.integer "subscription_id"
  end

  add_index "charges", ["subscription_id"], name: "index_charges_on_subscription_id", using: :btree

  create_table "license_fees", force: :cascade do |t|
    t.date    "start_date"
    t.decimal "amount",     precision: 10, scale: 2
    t.integer "license_id"
  end

  add_index "license_fees", ["license_id"], name: "index_license_fees_on_license_id", using: :btree

  create_table "license_mappings", force: :cascade do |t|
    t.integer "mappable_id"
    t.string  "mappable_type"
    t.integer "license_id"
  end

  add_index "license_mappings", ["license_id"], name: "index_license_mappings_on_license_id", using: :btree
  add_index "license_mappings", ["mappable_type", "mappable_id"], name: "index_license_mappings_on_mappable_type_and_mappable_id", using: :btree

  create_table "licenses", force: :cascade do |t|
    t.string  "name"
    t.integer "licensing_type", default: 0
    t.integer "licensor_id",    default: 0
    t.integer "status",         default: 0
    t.string  "sku"
  end

  add_index "licenses", ["licensor_id"], name: "index_licenses_on_licensor_id", using: :btree

  create_table "licensors", force: :cascade do |t|
    t.string  "name"
    t.integer "status",      default: 0
    t.integer "reseller_id"
  end

  add_index "licensors", ["reseller_id"], name: "licensors_reseller_id_idx", using: :btree

  create_table "plan_resources", force: :cascade do |t|
    t.string  "name"
    t.decimal "amount",  precision: 10, scale: 2
    t.integer "plan_id"
  end

  add_index "plan_resources", ["plan_id"], name: "index_plan_resources_on_plan_id", using: :btree

  create_table "plans", force: :cascade do |t|
    t.string "name"
  end

  create_table "resellers", force: :cascade do |t|
    t.string "name"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string  "name"
    t.integer "plan_id"
    t.integer "account_id"
    t.date    "start_date"
  end

  add_index "subscriptions", ["account_id"], name: "index_subscriptions_on_account_id", using: :btree
  add_index "subscriptions", ["plan_id"], name: "index_subscriptions_on_plan_id", using: :btree

  add_foreign_key "charges", "subscriptions"
  add_foreign_key "license_fees", "licenses"
  add_foreign_key "license_mappings", "licenses"
  add_foreign_key "licenses", "licensors"
  add_foreign_key "subscriptions", "accounts"
  add_foreign_key "subscriptions", "plans"
end
