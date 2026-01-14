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

ActiveRecord::Schema[7.2].define(version: 2025_12_09_181457) do
  create_table "expense_shares", force: :cascade do |t|
    t.integer "expense_id", null: false
    t.integer "debtor_id", null: false
    t.decimal "amount_owed", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["debtor_id"], name: "index_expense_shares_on_debtor_id"
    t.index ["expense_id"], name: "index_expense_shares_on_expense_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.integer "trip_id", null: false
    t.integer "payer_id", null: false
    t.decimal "amount", precision: 10, scale: 2
    t.string "description"
    t.string "category"
    t.date "incurred_date"
    t.string "raw_currency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "due_date"
    t.index ["payer_id"], name: "index_expenses_on_payer_id"
    t.index ["trip_id"], name: "index_expenses_on_trip_id"
  end

  create_table "trip_memberships", force: :cascade do |t|
    t.integer "trip_id", null: false
    t.integer "attendee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "expense_percentage", precision: 5, scale: 2, default: "0.0"
    t.index ["attendee_id"], name: "index_trip_memberships_on_attendee_id"
    t.index ["trip_id", "attendee_id"], name: "index_trip_memberships_on_trip_id_and_attendee_id", unique: true
    t.index ["trip_id"], name: "index_trip_memberships_on_trip_id"
  end

  create_table "trips", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.date "start_date"
    t.date "end_date"
    t.string "base_currency"
    t.integer "creator_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "creator_expense_percentage", precision: 5, scale: 2, default: "0.0"
    t.index ["creator_id"], name: "index_trips_on_creator_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "full_name"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "expense_shares", "expenses"
  add_foreign_key "expense_shares", "users", column: "debtor_id"
  add_foreign_key "expenses", "trips"
  add_foreign_key "expenses", "users", column: "payer_id"
  add_foreign_key "trip_memberships", "trips"
  add_foreign_key "trip_memberships", "users", column: "attendee_id"
  add_foreign_key "trips", "users", column: "creator_id"
end
