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

ActiveRecord::Schema.define(version: 20140528172526) do

  create_table "groups", force: true do |t|
    t.string   "name"
    t.string   "book_name"
    t.integer  "page_number"
    t.text     "description"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "num_to_read", default: 0
    t.integer  "admin_id"
  end

  add_index "groups", ["name"], name: "index_groups_on_name", unique: true

  create_table "user_groups", force: true do |t|
    t.integer  "num_read",   default: 0
    t.boolean  "admin",      default: false
    t.integer  "user_id",                    null: false
    t.integer  "group_id",                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_groups", ["group_id"], name: "index_user_groups_on_group_id"
  add_index "user_groups", ["user_id", "group_id"], name: "index_user_groups_on_user_id_and_group_id", unique: true
  add_index "user_groups", ["user_id"], name: "index_user_groups_on_user_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "login"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "active",          default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",           default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["login"], name: "index_users_on_login", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
