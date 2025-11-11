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

ActiveRecord::Schema[7.2].define(version: 2025_11_11_070130) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.bigint "consultation_id", null: false
    t.string "question", null: false
    t.text "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["consultation_id"], name: "index_answers_on_consultation_id"
  end

  create_table "consultation_sharings", force: :cascade do |t|
    t.bigint "consultation_id", null: false
    t.string "shared_token"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["consultation_id"], name: "index_consultation_sharings_on_consultation_id"
    t.index ["shared_token"], name: "index_consultation_sharings_on_shared_token", unique: true
  end

  create_table "consultations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "status", default: "draft", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "uuid_url", default: -> { "gen_random_uuid()" }, null: false
    t.bigint "salon_id"
    t.index ["salon_id"], name: "index_consultations_on_salon_id"
    t.index ["user_id"], name: "index_consultations_on_user_id"
    t.index ["uuid_url"], name: "index_consultations_on_uuid_url", unique: true
  end

  create_table "events", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.datetime "start_time", null: false
    t.datetime "end_time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "salons", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "salon_name", null: false
    t.index ["email"], name: "index_salons_on_email", unique: true
    t.index ["reset_password_token"], name: "index_salons_on_reset_password_token", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "full_name", null: false
    t.string "gender"
    t.string "age_group"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "answers", "consultations"
  add_foreign_key "consultation_sharings", "consultations"
  add_foreign_key "consultations", "salons"
  add_foreign_key "consultations", "users"
  add_foreign_key "events", "users"
end
