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

ActiveRecord::Schema.define(version: 20160209125950) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.integer  "priority"
    t.string   "name"
    t.string   "icon"
    t.string   "library"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "comments", ["post_id"], name: "index_comments_on_post_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "event_users", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "event_users", ["event_id"], name: "index_event_users_on_event_id", using: :btree
  add_index "event_users", ["user_id"], name: "index_event_users_on_user_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.integer  "number"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "category_id"
    t.boolean  "closed"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "posts", ["category_id"], name: "index_posts_on_category_id", using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "recommendations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "recommender_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.boolean  "confirmed"
  end

  add_index "recommendations", ["recommender_id"], name: "index_recommendations_on_recommender_id", using: :btree
  add_index "recommendations", ["user_id", "recommender_id"], name: "index_recommendations_on_user_id_and_recommender_id", unique: true, using: :btree
  add_index "recommendations", ["user_id"], name: "index_recommendations_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "firstname"
    t.string   "lastname"
    t.boolean  "admin"
    t.integer  "confirmed"
    t.integer  "sleeping"
    t.string   "maidenname"
    t.string   "nickname"
    t.string   "gender"
    t.string   "company"
    t.string   "string"
    t.string   "occupation"
    t.string   "phone"
    t.string   "city"
    t.text     "image_meta_data"
    t.text     "auth_meta_data"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "facebook"
    t.string   "linkedin"
    t.string   "twitter"
    t.text     "description"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree

  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "event_users", "events"
  add_foreign_key "event_users", "users"
  add_foreign_key "posts", "categories"
  add_foreign_key "posts", "users"
end
