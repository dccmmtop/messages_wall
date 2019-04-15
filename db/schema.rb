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

ActiveRecord::Schema.define(version: 20190414064617) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.text "body"
    t.integer "message_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.boolean "is_delete", default: false
  end

  create_table "likes", force: :cascade do |t|
    t.string "likeable_type"
    t.integer "likeable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.integer "user_id"
    t.text "content"
    t.integer "limit_user_accounts"
    t.integer "limit_days"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.boolean "is_delete", default: false
    t.boolean "is_comment", default: true
    t.string "location"
    t.integer "read_count", default: 0
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "user_id"
    t.integer "admin_id"
    t.text "content"
    t.boolean "is_read"
    t.boolean "is_delete", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "message_id"
    t.string "category"
    t.integer "time_id"
  end

  create_table "reads", force: :cascade do |t|
    t.integer "user_id"
    t.integer "message_id"
    t.integer "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "ime"
    t.string "nickname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin"
    t.string "password_digest"
    t.string "email"
    t.string "token"
    t.string "avatar"
    t.boolean "is_delete", default: false
  end

end
