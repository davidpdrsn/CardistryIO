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

ActiveRecord::Schema.define(version: 20160621120444) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string   "subject_type", null: false
    t.integer  "subject_id",   null: false
    t.integer  "user_id",      null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["subject_id", "subject_type"], name: "index_activities_on_subject_id_and_subject_type", using: :btree
    t.index ["user_id"], name: "index_activities_on_user_id", using: :btree
  end

  create_table "appearances", force: :cascade do |t|
    t.integer "move_id",  null: false
    t.integer "video_id", null: false
    t.integer "minutes"
    t.integer "seconds"
    t.index ["move_id"], name: "index_appearances_on_move_id", using: :btree
    t.index ["video_id"], name: "index_appearances_on_video_id", using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.text     "content"
    t.string   "commentable_type", null: false
    t.integer  "commentable_id",   null: false
    t.integer  "user_id",          null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
  end

  create_table "credits", force: :cascade do |t|
    t.string   "creditable_type", null: false
    t.integer  "creditable_id",   null: false
    t.integer  "user_id",         null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["creditable_id", "creditable_type"], name: "index_credits_on_creditable_id_and_creditable_type", using: :btree
    t.index ["user_id"], name: "index_credits_on_user_id", using: :btree
  end

  create_table "moves", force: :cascade do |t|
    t.string   "name",                        null: false
    t.text     "description"
    t.integer  "user_id",                     null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "idea",        default: false, null: false
    t.index ["name"], name: "index_moves_on_name", unique: true, using: :btree
    t.index ["user_id"], name: "index_moves_on_user_id", using: :btree
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id",                           null: false
    t.string   "subject_type",                      null: false
    t.integer  "subject_id",                        null: false
    t.integer  "actor_id",                          null: false
    t.boolean  "seen",              default: false, null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "notification_type",                 null: false
    t.index ["actor_id"], name: "index_notifications_on_actor_id", using: :btree
    t.index ["subject_id", "subject_type"], name: "index_notifications_on_subject_id_and_subject_type", using: :btree
  end

  create_table "ratings", force: :cascade do |t|
    t.integer  "rating",        null: false
    t.string   "rateable_type", null: false
    t.integer  "rateable_id",   null: false
    t.integer  "user_id",       null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["rateable_id", "rateable_type"], name: "index_ratings_on_rateable_id_and_rateable_type", using: :btree
    t.index ["rating"], name: "index_ratings_on_rating", using: :btree
    t.index ["user_id"], name: "index_ratings_on_user_id", using: :btree
  end

  create_table "relationships", force: :cascade do |t|
    t.integer  "follower_id",                null: false
    t.integer  "followee_id",                null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "active",      default: true, null: false
    t.index ["followee_id"], name: "index_relationships_on_followee_id", using: :btree
    t.index ["follower_id"], name: "index_relationships_on_follower_id", using: :btree
  end

  create_table "sharings", force: :cascade do |t|
    t.integer  "video_id",   null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sharings_on_user_id", using: :btree
    t.index ["video_id"], name: "index_sharings_on_video_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "email",                                          null: false
    t.string   "encrypted_password", limit: 128,                 null: false
    t.string   "confirmation_token", limit: 128
    t.string   "remember_token",     limit: 128,                 null: false
    t.boolean  "admin",                          default: false, null: false
    t.string   "username",                                       null: false
    t.string   "instagram_username"
    t.text     "biography"
    t.string   "time_zone",                                      null: false
    t.string   "country_code",                                   null: false
    t.index ["email"], name: "index_users_on_email", using: :btree
    t.index ["instagram_username"], name: "index_users_on_instagram_username", unique: true, using: :btree
    t.index ["remember_token"], name: "index_users_on_remember_token", using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

  create_table "video_views", force: :cascade do |t|
    t.integer  "video_id",   null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_video_views_on_user_id", using: :btree
    t.index ["video_id"], name: "index_video_views_on_video_id", using: :btree
  end

  create_table "videos", force: :cascade do |t|
    t.string   "name",                          null: false
    t.text     "description"
    t.string   "url",                           null: false
    t.integer  "user_id",                       null: false
    t.boolean  "approved",      default: false, null: false
    t.boolean  "private",       default: false, null: false
    t.string   "instagram_id"
    t.integer  "video_type",                    null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "thumbnail_url"
    t.index ["name"], name: "index_videos_on_name", using: :btree
    t.index ["user_id"], name: "index_videos_on_user_id", using: :btree
  end

end
