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

ActiveRecord::Schema.define(version: 20180905185536) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "secret_parts", force: :cascade do |t|
    t.bigint "secret_id"
    t.string "key"
    t.text "encrypted_data"
    t.index ["secret_id"], name: "index_secret_parts_on_secret_id"
  end

  create_table "secrets", force: :cascade do |t|
    t.string "public_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uuid"
    t.datetime "sealed_at"
    t.text "message"
    t.string "signature"
  end

  add_foreign_key "secret_parts", "secrets"
end
