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

ActiveRecord::Schema.define(version: 20160501030459) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace",     limit: 255
    t.text     "body"
    t.string   "resource_id",   limit: 255, null: false
    t.string   "resource_type", limit: 255, null: false
    t.integer  "author_id"
    t.string   "author_type",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "entities", force: :cascade do |t|
    t.string   "entity_name",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "import_key",     limit: 255, default: "",    null: false
    t.integer  "entity_type_id",             default: 0
    t.boolean  "status",                     default: false
  end

  add_index "entities", ["import_key"], name: "index_entities_on_import_key", unique: true, using: :btree

  create_table "entity_types", force: :cascade do |t|
    t.string   "entity_type_name",         limit: 255
    t.string   "entity_type_abbreviation", limit: 255
    t.integer  "sort"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "import_key"
  end

  add_index "entity_types", ["import_key"], name: "index_entity_types_on_import_key", unique: true, using: :btree

  create_table "events", force: :cascade do |t|
    t.integer  "entity_id"
    t.string   "event_name",  limit: 255
    t.text     "description"
    t.datetime "start_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "import_key",  limit: 255, default: "",    null: false
    t.boolean  "date_tba",                default: false
    t.boolean  "time_tba",                default: false
  end

  add_index "events", ["entity_id"], name: "index_events_on_entity_id", using: :btree
  add_index "events", ["import_key"], name: "index_events_on_import_key", unique: true, using: :btree

  create_table "group_invitations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.string   "email",           limit: 255
    t.string   "invitation_code", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "status",                      default: false
  end

  add_index "group_invitations", ["group_id"], name: "index_group_invitations_on_group_id", using: :btree
  add_index "group_invitations", ["invitation_code"], name: "index_group_invitations_on_invitation_code", unique: true, using: :btree
  add_index "group_invitations", ["user_id"], name: "index_group_invitations_on_user_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.integer  "entity_id"
    t.string   "group_name",          limit: 255
    t.integer  "creator_id"
    t.string   "invitation_code",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name",    limit: 255
    t.string   "avatar_content_type", limit: 255
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean  "status",                          default: false
  end

  add_index "groups", ["creator_id"], name: "index_groups_on_creator_id", using: :btree
  add_index "groups", ["entity_id"], name: "index_groups_on_entity_id", using: :btree
  add_index "groups", ["invitation_code"], name: "index_groups_on_invitation_code", unique: true, using: :btree

  create_table "memberships", id: false, force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.string   "role",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "daily_reminder",              default: false
    t.boolean  "weekly_reminder",             default: false
    t.boolean  "mine_only",                   default: false
  end

  add_index "memberships", ["group_id", "user_id"], name: "index_memberships_on_group_id_and_user_id", using: :btree

  create_table "ticket_files", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "ticket_id"
    t.string   "path",       limit: 255
    t.string   "file_name",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ticket_files", ["ticket_id"], name: "index_ticket_files_on_ticket_id", using: :btree

  create_table "ticket_histories", force: :cascade do |t|
    t.integer  "ticket_id"
    t.integer  "group_id"
    t.integer  "event_id"
    t.integer  "user_id"
    t.text     "entry"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tickets", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "event_id"
    t.integer  "owner_id"
    t.integer  "user_id"
    t.integer  "alias_id"
    t.string   "section",    limit: 255
    t.string   "row",        limit: 255
    t.string   "seat",       limit: 255
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

  create_table "user_aliases", force: :cascade do |t|
    t.string   "first_name", limit: 255
    t.string   "last_name",  limit: 255
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "timezone",               limit: 255
    t.text     "bio"
    t.string   "location",               limit: 255
    t.string   "mobile",                 limit: 255
    t.boolean  "sms_notify"
    t.string   "calendar_token",         limit: 255
    t.string   "provider"
    t.string   "uid"
    t.boolean  "status",                             default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["provider"], name: "index_users_on_provider", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", using: :btree

end
