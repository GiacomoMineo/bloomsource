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

ActiveRecord::Schema.define(version: 20150924113614) do

  create_table "Entries_Tags", id: false, force: :cascade do |t|
    t.integer "entry_id", null: false
    t.integer "tag_id",   null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "library_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entries", force: :cascade do |t|
    t.string   "title"
    t.text     "link"
    t.text     "description"
    t.integer  "rating"
    t.integer  "section_id"
    t.integer  "group",       default: 0
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "libraries", force: :cascade do |t|
    t.string   "topic"
    t.text     "description"
    t.integer  "creator_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "libraries", ["creator_id"], name: "index_libraries_on_creator_id"

  create_table "read_marks", force: :cascade do |t|
    t.integer  "readable_id"
    t.string   "readable_type", null: false
    t.integer  "user_id",       null: false
    t.datetime "timestamp"
  end

  add_index "read_marks", ["user_id", "readable_type", "readable_id"], name: "index_read_marks_on_user_id_and_readable_type_and_readable_id"

  create_table "sections", force: :cascade do |t|
    t.string   "name"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "library_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "subscriptions", ["library_id"], name: "index_subscriptions_on_library_id"
  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id"

  create_table "suggestions", force: :cascade do |t|
    t.integer  "creator_id"
    t.integer  "receiver_id"
    t.integer  "library_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "suggestions", ["creator_id"], name: "index_suggestions_on_creator_id"
  add_index "suggestions", ["library_id"], name: "index_suggestions_on_library_id"
  add_index "suggestions", ["receiver_id"], name: "index_suggestions_on_receiver_id"

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true

  create_table "users", force: :cascade do |t|
    t.string   "user_name"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["user_name"], name: "index_users_on_user_name", unique: true

  create_table "votes", force: :cascade do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope"
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope"

end
