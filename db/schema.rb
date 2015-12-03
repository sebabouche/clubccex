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

ActiveRecord::Schema.define(version: 20151203152336) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "departments", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "section_id"
  end

  add_index "departments", ["section_id"], name: "index_departments_on_section_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.integer  "number"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "positions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "department_id"
    t.boolean  "president"
    t.boolean  "treasurer"
    t.boolean  "secretariat"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "positions", ["department_id"], name: "index_positions_on_department_id", using: :btree
  add_index "positions", ["user_id"], name: "index_positions_on_user_id", using: :btree

  create_table "recommendations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "recommender_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "recommendations", ["recommender_id"], name: "index_recommendations_on_recommender_id", using: :btree
  add_index "recommendations", ["user_id", "recommender_id"], name: "index_recommendations_on_user_id_and_recommender_id", unique: true, using: :btree
  add_index "recommendations", ["user_id"], name: "index_recommendations_on_user_id", using: :btree

  create_table "sections", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "event_id"
  end

  add_index "sections", ["event_id"], name: "index_sections_on_event_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.text     "auth_meta_data"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "firstname"
    t.string   "lastname"
    t.string   "maidenname"
    t.string   "nickname"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree

  add_foreign_key "departments", "sections"
  add_foreign_key "positions", "departments"
  add_foreign_key "positions", "users"
  add_foreign_key "sections", "events"
end
