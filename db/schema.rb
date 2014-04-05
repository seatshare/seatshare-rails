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

ActiveRecord::Schema.define(version: 20140403043152) do

  create_table "entities", force: true do |t|
    t.string   "entity_name"
    t.string   "logo"
    t.integer  "status",      default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "entities", ["entity_name"], name: "index_entities_on_entity_name", unique: true

  create_table "events", force: true do |t|
    t.integer  "entity_id"
    t.string   "event_name"
    t.text     "description"
    t.datetime "start_time"
    t.integer  "date_tba"
    t.integer  "time_tba"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["entity_id"], name: "index_events_on_entity_id"

  create_table "group_invitations", force: true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.string   "email"
    t.string   "invitation_code"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_invitations", ["group_id"], name: "index_group_invitations_on_group_id"
  add_index "group_invitations", ["invitation_code"], name: "index_group_invitations_on_invitation_code", unique: true
  add_index "group_invitations", ["user_id"], name: "index_group_invitations_on_user_id"

  create_table "group_users", id: false, force: true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_users", ["group_id", "user_id"], name: "index_group_users_on_group_id_and_user_id"

  create_table "groups", force: true do |t|
    t.integer  "entity_id"
    t.string   "group_name"
    t.integer  "creator_id"
    t.string   "invitation_code"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["creator_id"], name: "index_groups_on_creator_id"
  add_index "groups", ["entity_id"], name: "index_groups_on_entity_id"
  add_index "groups", ["invitation_code"], name: "index_groups_on_invitation_code", unique: true

  create_table "reminders", force: true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.integer  "reminder_type_id"
    t.text     "entry"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reminders", ["user_id"], name: "index_reminders_on_user_id"

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

  add_index "ticket_files", ["ticket_id"], name: "index_ticket_files_on_ticket_id"

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

  add_index "tickets", ["alias_id"], name: "index_tickets_on_alias_id"
  add_index "tickets", ["event_id"], name: "index_tickets_on_event_id"
  add_index "tickets", ["group_id"], name: "index_tickets_on_group_id"
  add_index "tickets", ["owner_id"], name: "index_tickets_on_owner_id"
  add_index "tickets", ["user_id"], name: "index_tickets_on_user_id"

  create_table "user_aliases", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_reminders", id: false, force: true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.integer  "reminder_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_reminders", ["group_id", "user_id"], name: "index_user_reminders_on_group_id_and_user_id"

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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
