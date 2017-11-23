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

ActiveRecord::Schema.define(version: 20171012025217) do

  create_table "groups", force: :cascade do |t|
    t.integer "manager_id"
    t.index ["manager_id"], name: "index_groups_on_manager_id"
  end

  create_table "managers", force: :cascade do |t|
    t.integer "supervisor_id"
    t.index ["supervisor_id"], name: "index_managers_on_supervisor_id"
  end

  create_table "names", force: :cascade do |t|
    t.text "name"
    t.text "kana"
    t.string "data_type"
    t.integer "data_id"
    t.index ["data_type", "data_id"], name: "index_names_on_data_type_and_data_id"
  end

  create_table "supervisors", force: :cascade do |t|
    t.text "test"
  end

  create_table "user_configs", force: :cascade do |t|
    t.integer "user_id"
    t.index ["user_id"], name: "index_user_configs_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "group_id"
    t.index ["group_id"], name: "index_users_on_group_id"
  end

end
