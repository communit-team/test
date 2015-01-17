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

ActiveRecord::Schema.define(version: 20150117184326) do

  create_table "follow_relations", force: true do |t|
    t.integer  "follower_id"
    t.integer  "following_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "engaged"
    t.boolean  "new",          default: true
  end

  create_table "unfollow_relations", force: true do |t|
    t.integer  "unfollower_id"
    t.integer  "unfollowing_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "unfollow_relations", ["unfollower_id", "unfollowing_id"], name: "index_unfollow_relations_on_unfollower_id_and_unfollowing_id", unique: true
  add_index "unfollow_relations", ["unfollower_id"], name: "index_unfollow_relations_on_unfollower_id"
  add_index "unfollow_relations", ["unfollowing_id"], name: "index_unfollow_relations_on_unfollowing_id"

  create_table "users", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uid"
    t.string   "name"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.integer  "number_of_followers"
    t.text     "profile_image_url"
    t.text     "screen_name"
  end

end
