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

ActiveRecord::Schema.define(version: 20180423115109) do

  create_table "contributions", force: :cascade do |t|
    t.string "contribution_type"
    t.string "name"
    t.string "description"
    t.string "status"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "commits", default: 0
    t.integer "pull_requests", default: 0
    t.integer "issues", default: 0
    t.integer "total", default: 0
    t.integer "mentor_id"
    t.integer "mentee_id"
    t.index ["mentee_id"], name: "index_contributions_on_mentee_id"
    t.index ["mentor_id"], name: "index_contributions_on_mentor_id"
    t.index ["user_id"], name: "index_contributions_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.integer "status"
  end

  create_table "repos", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.integer "user_id"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role_type"
    t.index ["project_id"], name: "index_roles_on_project_id"
    t.index ["user_id"], name: "index_roles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.string "oauth_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin"
    t.integer "commits", default: 0
    t.integer "pull_requests", default: 0
    t.integer "issues", default: 0
    t.integer "total", default: 0
  end

end
