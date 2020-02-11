# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_02_11_023827) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_lines", force: :cascade do |t|
    t.bigint "user_id"
    t.text "nonce"
    t.text "line_user"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_account_lines_on_user_id"
  end

  create_table "account_telegrams", force: :cascade do |t|
    t.text "telegram_user"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_account_telegrams_on_user_id"
  end

  create_table "bit_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id", null: false
    t.integer "descendant_id", null: false
    t.integer "generations", null: false
    t.index ["ancestor_id", "descendant_id", "generations"], name: "bit_anc_desc_idx", unique: true
    t.index ["descendant_id"], name: "bit_desc_idx"
  end

  create_table "bits", force: :cascade do |t|
    t.text "title", null: false
    t.text "description"
    t.text "content"
    t.text "uri"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "parent_id"
    t.integer "sort_order"
    t.datetime "due_at"
    t.integer "status", default: 0
    t.string "bookmarking_type"
    t.bigint "bookmarking_id"
    t.datetime "begin_at"
    t.datetime "end_at"
    t.boolean "all_day", default: false
    t.jsonb "time_zone", default: {}, null: false
    t.bigint "predecessor_id"
    t.index ["bookmarking_type", "bookmarking_id"], name: "index_bits_on_bookmarking_type_and_bookmarking_id"
    t.index ["predecessor_id"], name: "index_bits_on_predecessor_id"
  end

  create_table "constituents", force: :cascade do |t|
    t.bigint "workspace_id", null: false
    t.bigint "bit_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["bit_id"], name: "index_constituents_on_bit_id"
    t.index ["workspace_id"], name: "index_constituents_on_workspace_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "workspace_id", null: false
    t.integer "role", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_memberships_on_user_id"
    t.index ["workspace_id"], name: "index_memberships_on_workspace_id"
  end

  create_table "ownerships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "bit_id", null: false
    t.text "tags", array: true
    t.boolean "favorite", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["bit_id"], name: "index_ownerships_on_bit_id"
    t.index ["tags"], name: "index_ownerships_on_tags", using: :gin
    t.index ["user_id"], name: "index_ownerships_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.jsonb "preferences", default: {"time_zone"=>"UTC"}, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "workspaces", force: :cascade do |t|
    t.text "title", null: false
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "account_lines", "users", on_delete: :cascade
  add_foreign_key "account_telegrams", "users", on_delete: :cascade
  add_foreign_key "bits", "bits", column: "predecessor_id"
  add_foreign_key "constituents", "bits", on_delete: :cascade
  add_foreign_key "constituents", "workspaces", on_delete: :cascade
  add_foreign_key "memberships", "users", on_delete: :cascade
  add_foreign_key "memberships", "workspaces", on_delete: :cascade
  add_foreign_key "ownerships", "bits", on_delete: :cascade
  add_foreign_key "ownerships", "users", on_delete: :cascade
end
