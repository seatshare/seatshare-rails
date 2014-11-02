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

ActiveRecord::Schema.define(version: 20141102020534) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: true do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "entities", force: true do |t|
    t.string   "entity_name"
    t.integer  "status",      default: 0,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "import_key",  default: "", null: false
    t.string   "entity_type", default: "", null: false
  end

  add_index "entities", ["entity_name", "entity_type"], name: "index_entities_on_entity_name_and_entity_type", unique: true, using: :btree
  add_index "entities", ["import_key"], name: "index_entities_on_import_key", unique: true, using: :btree

  create_table "events", force: true do |t|
    t.integer  "entity_id"
    t.string   "event_name"
    t.text     "description"
    t.datetime "start_time"
    t.integer  "date_tba"
    t.integer  "time_tba"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "import_key",  default: "", null: false
  end

  add_index "events", ["entity_id"], name: "index_events_on_entity_id", using: :btree
  add_index "events", ["import_key"], name: "index_events_on_import_key", unique: true, using: :btree

  create_table "group_invitations", force: true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.string   "email"
    t.string   "invitation_code"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_invitations", ["group_id"], name: "index_group_invitations_on_group_id", using: :btree
  add_index "group_invitations", ["invitation_code"], name: "index_group_invitations_on_invitation_code", unique: true, using: :btree
  add_index "group_invitations", ["user_id"], name: "index_group_invitations_on_user_id", using: :btree

  create_table "group_users", id: false, force: true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.string   "role"
    t.integer  "daily_reminder"
    t.integer  "weekly_reminder"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_users", ["group_id", "user_id"], name: "index_group_users_on_group_id_and_user_id", using: :btree

  create_table "groups", force: true do |t|
    t.integer  "entity_id"
    t.string   "group_name"
    t.integer  "creator_id"
    t.string   "invitation_code"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["creator_id"], name: "index_groups_on_creator_id", using: :btree
  add_index "groups", ["entity_id"], name: "index_groups_on_entity_id", using: :btree
  add_index "groups", ["invitation_code"], name: "index_groups_on_invitation_code", unique: true, using: :btree

  create_table "profiles", force: true do |t|
    t.integer  "user_id"
    t.text     "bio"
    t.string   "location"
    t.string   "mobile"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", force: true do |t|
    t.integer  "group_id"
    t.string   "customer_id"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ticket_files", force: true do |t|
    t.integer  "user_id"
    t.integer  "ticket_id"
    t.string   "path"
    t.string   "file_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ticket_files", ["ticket_id"], name: "index_ticket_files_on_ticket_id", using: :btree

  create_table "ticket_histories", force: true do |t|
    t.integer  "ticket_id"
    t.integer  "group_id"
    t.integer  "event_id"
    t.integer  "user_id"
    t.text     "entry"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tickets", force: true do |t|
    t.integer  "group_id"
    t.integer  "event_id"
    t.integer  "owner_id"
    t.integer  "user_id"
    t.integer  "alias_id"
    t.string   "section"
    t.string   "row"
    t.string   "seat"
    t.decimal  "cost"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tickets", ["alias_id"], name: "index_tickets_on_alias_id", using: :btree
  add_index "tickets", ["event_id"], name: "index_tickets_on_event_id", using: :btree
  add_index "tickets", ["group_id"], name: "index_tickets_on_group_id", using: :btree
  add_index "tickets", ["owner_id"], name: "index_tickets_on_owner_id", using: :btree
  add_index "tickets", ["user_id"], name: "index_tickets_on_user_id", using: :btree

  create_table "user_aliases", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.string   "timezone"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
