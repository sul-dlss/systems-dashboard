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

ActiveRecord::Schema.define(version: 2016_04_29_050032) do

  create_table "details", force: :cascade do |t|
    t.integer "server_id"
    t.string "category"
    t.string "name"
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["server_id", "category", "name"], name: "index_details_on_server_id_and_category_and_name", unique: true
  end

  create_table "servers", force: :cascade do |t|
    t.string "hostname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
