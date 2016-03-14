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

ActiveRecord::Schema.define(version: 20160314111344) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"
  enable_extension "fuzzystrmatch"
  enable_extension "unaccent"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "library_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "categories", ["slug"], name: "index_categories_on_slug", using: :btree

  create_table "entries", force: :cascade do |t|
    t.string   "title"
    t.text     "link"
    t.text     "description"
    t.integer  "section_id"
    t.integer  "group_id"
    t.boolean  "accepted",           default: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "cached_votes_total", default: 0
    t.integer  "cached_votes_score", default: 0
    t.integer  "cached_votes_up",    default: 0
    t.integer  "cached_votes_down",  default: 0
    t.string   "author",             default: ""
    t.integer  "readingtime",        default: 0
  end

  add_index "entries", ["cached_votes_down"], name: "index_entries_on_cached_votes_down", using: :btree
  add_index "entries", ["cached_votes_score"], name: "index_entries_on_cached_votes_score", using: :btree
  add_index "entries", ["cached_votes_total"], name: "index_entries_on_cached_votes_total", using: :btree
  add_index "entries", ["cached_votes_up"], name: "index_entries_on_cached_votes_up", using: :btree

  create_table "entries_tags", id: false, force: :cascade do |t|
    t.integer "entry_id", null: false
    t.integer "tag_id",   null: false
  end

  create_table "esuggestions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "feedbacks", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "subject"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.integer  "library_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "informers", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invitations", force: :cascade do |t|
    t.integer  "creator_id"
    t.integer  "library_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "receiver_email"
  end

  add_index "invitations", ["creator_id"], name: "index_invitations_on_creator_id", using: :btree
  add_index "invitations", ["library_id"], name: "index_invitations_on_library_id", using: :btree
  add_index "invitations", ["receiver_email"], name: "index_invitations_on_receiver_email", unique: true, using: :btree

  create_table "libraries", force: :cascade do |t|
    t.string   "topic"
    t.text     "description"
    t.boolean  "public",      default: true
    t.integer  "creator_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "slug"
  end

  add_index "libraries", ["creator_id"], name: "index_libraries_on_creator_id", using: :btree
  add_index "libraries", ["slug"], name: "index_libraries_on_slug", using: :btree

  create_table "libraries_users", id: false, force: :cascade do |t|
    t.integer "library_id", null: false
    t.integer "user_id",    null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  create_table "sections", force: :cascade do |t|
    t.string   "name"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "sections", ["slug"], name: "index_sections_on_slug", using: :btree

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "library_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "subscriptions", ["library_id"], name: "index_subscriptions_on_library_id", using: :btree
  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "library_id"
  end

  add_index "tags", ["library_id"], name: "index_tags_on_library_id", using: :btree
  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "user_name"
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.integer  "mode",                   default: 0
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "admin",                  default: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["user_name"], name: "index_users_on_user_name", unique: true, using: :btree

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

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree

  add_foreign_key "tags", "libraries"
end
