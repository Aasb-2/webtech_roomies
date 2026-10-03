# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_10_01_120008) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "applications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "duration_months"
    t.bigint "listing_id", null: false
    t.text "message"
    t.date "move_in_date", null: false
    t.bigint "seeker_id", null: false
    t.string "state", default: "pending", null: false
    t.datetime "updated_at", null: false
    t.index ["listing_id", "seeker_id"], name: "index_applications_on_listing_and_seeker", unique: true
    t.index ["listing_id"], name: "index_applications_on_listing_id"
    t.index ["seeker_id"], name: "index_applications_on_seeker_id"
    t.index ["state"], name: "index_applications_on_state"
  end

  create_table "item_models", force: :cascade do |t|
    t.string "brand", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "listings", force: :cascade do |t|
    t.date "available_date", null: false
    t.datetime "created_at", null: false
    t.decimal "deposit", precision: 10, scale: 2, null: false
    t.text "description"
    t.boolean "furnished", default: false, null: false
    t.integer "minimum_stay"
    t.decimal "monthly_rent", precision: 10, scale: 2, null: false
    t.boolean "private_bathroom", default: false, null: false
    t.bigint "property_id", null: false
    t.string "state", default: "draft", null: false
    t.datetime "updated_at", null: false
    t.index ["available_date"], name: "index_listings_on_available_date"
    t.index ["monthly_rent"], name: "index_listings_on_monthly_rent"
    t.index ["property_id"], name: "index_listings_on_property_id"
    t.index ["state"], name: "index_listings_on_state"
  end

  create_table "properties", force: :cascade do |t|
    t.string "address", null: false
    t.string "amenities", default: [], null: false, array: true
    t.integer "bathrooms", null: false
    t.integer "bedrooms", null: false
    t.datetime "created_at", null: false
    t.bigint "host_id", null: false
    t.string "neighborhood", null: false
    t.string "property_type", null: false
    t.text "shared_spaces"
    t.datetime "updated_at", null: false
    t.index ["amenities"], name: "index_properties_on_amenities", using: :gin
    t.index ["host_id"], name: "index_properties_on_host_id"
    t.index ["neighborhood"], name: "index_properties_on_neighborhood"
  end

  create_table "reports", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "details"
    t.bigint "listing_id", null: false
    t.string "reason", null: false
    t.bigint "reporter_id", null: false
    t.string "status", default: "pending", null: false
    t.datetime "updated_at", null: false
    t.index ["listing_id"], name: "index_reports_on_listing_id"
    t.index ["reporter_id"], name: "index_reports_on_reporter_id"
    t.index ["status"], name: "index_reports_on_status"
  end

  create_table "reviews", force: :cascade do |t|
    t.text "comment"
    t.datetime "created_at", null: false
    t.bigint "property_id", null: false
    t.integer "rating", null: false
    t.bigint "seeker_id", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id", "seeker_id"], name: "index_reviews_on_property_and_seeker", unique: true
    t.index ["property_id"], name: "index_reviews_on_property_id"
    t.index ["seeker_id"], name: "index_reviews_on_seeker_id"
  end

  create_table "saved_listings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "listing_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["listing_id"], name: "index_saved_listings_on_listing_id"
    t.index ["user_id", "listing_id"], name: "index_saved_listings_on_user_and_listing", unique: true
    t.index ["user_id"], name: "index_saved_listings_on_user_id"
  end

  create_table "units", force: :cascade do |t|
    t.string "asset_tag", null: false
    t.datetime "created_at", null: false
    t.bigint "item_model_id"
    t.datetime "updated_at", null: false
    t.index ["item_model_id"], name: "index_units_on_item_model_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name", null: false
    t.string "role", default: "member", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "visits", force: :cascade do |t|
    t.bigint "application_id", null: false
    t.datetime "created_at", null: false
    t.datetime "proposed_date", null: false
    t.string "status", default: "scheduled", null: false
    t.datetime "updated_at", null: false
    t.index ["application_id"], name: "index_visits_on_application_id"
    t.index ["status"], name: "index_visits_on_status"
  end

  add_foreign_key "applications", "listings"
  add_foreign_key "applications", "users", column: "seeker_id"
  add_foreign_key "listings", "properties"
  add_foreign_key "properties", "users", column: "host_id"
  add_foreign_key "reports", "listings"
  add_foreign_key "reports", "users", column: "reporter_id"
  add_foreign_key "reviews", "properties"
  add_foreign_key "reviews", "users", column: "seeker_id"
  add_foreign_key "saved_listings", "listings"
  add_foreign_key "saved_listings", "users"
  add_foreign_key "units", "item_models"
  add_foreign_key "visits", "applications"
end
