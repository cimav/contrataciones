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

ActiveRecord::Schema.define(version: 20170506013520) do

  create_table "candidates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.integer  "department_id"
    t.integer  "status"
    t.integer  "level_id"
    t.string   "email"
    t.string   "function"
    t.string   "degree"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "curriculum"
    t.index ["department_id"], name: "index_candidates_on_department_id", using: :btree
    t.index ["level_id"], name: "index_candidates_on_level_id", using: :btree
  end

  create_table "departments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "levels", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "full_name"
    t.string   "short_name"
    t.string   "requirements"
    t.integer  "level_type"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "responses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "user_id"
    t.integer  "candidate_id"
    t.integer  "level_id"
    t.string   "comments"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["candidate_id"], name: "index_responses_on_candidate_id", using: :btree
    t.index ["level_id"], name: "index_responses_on_level_id", using: :btree
    t.index ["user_id"], name: "index_responses_on_user_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.integer  "department_id"
    t.string   "email"
    t.integer  "user_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["department_id"], name: "index_users_on_department_id", using: :btree
  end

  add_foreign_key "candidates", "departments"
  add_foreign_key "candidates", "levels"
  add_foreign_key "responses", "candidates"
  add_foreign_key "responses", "levels"
  add_foreign_key "responses", "users"
  add_foreign_key "users", "departments"
end
