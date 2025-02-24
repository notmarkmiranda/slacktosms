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

ActiveRecord::Schema[8.0].define(version: 2025_02_24_020347) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "slack_connections", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "slack_user_id", null: false
    t.string "access_token", null: false
    t.string "team_id", null: false
    t.string "team_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "team_id"], name: "index_slack_connections_on_user_id_and_team_id", unique: true
    t.index ["user_id"], name: "index_slack_connections_on_user_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "slack_connection_id", null: false
    t.string "channel_id", null: false
    t.string "channel_name", null: false
    t.string "last_seen_message_ts"
    t.boolean "is_private", default: false, null: false
    t.boolean "is_dm", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slack_connection_id", "channel_id"], name: "index_subscriptions_on_slack_connection_id_and_channel_id", unique: true
    t.index ["slack_connection_id"], name: "index_subscriptions_on_slack_connection_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "phone_number", null: false
    t.boolean "phone_verified", default: false, null: false
    t.string "verification_code"
    t.datetime "verification_code_expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["phone_number"], name: "index_users_on_phone_number", unique: true
  end

  add_foreign_key "slack_connections", "users"
  add_foreign_key "subscriptions", "slack_connections"
end
