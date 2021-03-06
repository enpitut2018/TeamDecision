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

ActiveRecord::Schema.define(version: 20180727100001) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.integer "Aid"
    t.integer "Pid"
    t.integer "Uid"
    t.integer "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "paramaters", force: :cascade do |t|
    t.integer "Rid"
    t.string "Pname"
    t.integer "key"
    t.integer "format"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "question"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "Rchar"
    t.string "Rname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "RadminKey"
  end

  create_table "teams", force: :cascade do |t|
    t.integer "Rid"
    t.integer "Tid"
    t.string "Tname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.integer "Rid"
    t.string "name"
    t.string "email"
    t.integer "key"
    t.integer "Tid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
