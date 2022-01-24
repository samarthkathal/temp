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

ActiveRecord::Schema.define(version: 2022_01_22_141147) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "campaigns", force: :cascade do |t|
    t.bigint "event_id"
    t.string "code", null: false
    t.string "name"
    t.boolean "state", default: false, null: false
    t.jsonb "conditions"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_campaigns_on_code", unique: true
    t.index ["event_id"], name: "index_campaigns_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.bigint "source_id"
    t.string "code", null: false
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_events_on_code", unique: true
    t.index ["source_id"], name: "index_events_on_source_id"
  end

  create_table "fields", force: :cascade do |t|
    t.bigint "event_id"
    t.string "code", null: false
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_fields_on_code", unique: true
    t.index ["event_id"], name: "index_fields_on_event_id"
  end

  create_table "sources", force: :cascade do |t|
    t.string "code", null: false
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_sources_on_code", unique: true
  end

  add_foreign_key "campaigns", "events"
  add_foreign_key "events", "sources"
  add_foreign_key "fields", "events"
end
