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

ActiveRecord::Schema.define(version: 20151212052937) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "labels", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "listens", force: :cascade do |t|
    t.integer  "radio_id"
    t.string   "ip_address", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "start_at"
    t.datetime "end_at"
  end

  create_table "plans", force: :cascade do |t|
    t.decimal  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",       default: "", null: false
  end

  create_table "playlist_tracks", force: :cascade do |t|
    t.integer  "track_id",               null: false
    t.integer  "playlist_id",            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.datetime "podcast_published_date"
  end

  create_table "playlists", force: :cascade do |t|
    t.integer  "radio_id",                                                               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                                       limit: 255
    t.integer  "interpolated_playlist_id"
    t.integer  "interpolated_playlist_track_play_count"
    t.integer  "interpolated_playlist_track_interval_count"
    t.boolean  "interpolated_playlist_enabled",                          default: false, null: false
  end

  create_table "podcasts", force: :cascade do |t|
    t.integer  "radio_id",                        null: false
    t.string   "title"
    t.string   "link"
    t.string   "description"
    t.datetime "last_build_date"
    t.string   "itunes_summary"
    t.string   "itunes_name"
    t.string   "itunes_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",               default: "", null: false
    t.integer  "playlist_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "extra_tags"
  end

  create_table "radios", force: :cascade do |t|
    t.string   "icecast_container_id",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                    limit: 255, default: "",   null: false
    t.integer  "subscription_id",                                    null: false
    t.string   "liquidsoap_container_id", limit: 255
    t.integer  "default_playlist_id"
    t.boolean  "enabled",                             default: true, null: false
  end

  create_table "recordings", force: :cascade do |t|
    t.integer  "radio_id"
    t.integer  "dj_id"
    t.integer  "show_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  create_table "scheduled_shows", force: :cascade do |t|
    t.integer  "show_id",                               null: false
    t.integer  "radio_id",                              null: false
    t.datetime "start_at",                              null: false
    t.datetime "end_at",                                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "recurring_interval",    default: 0,     null: false
    t.boolean  "recurrence",            default: false, null: false
    t.integer  "recurrant_original_id"
  end

  create_table "shows", force: :cascade do |t|
    t.string   "title",              limit: 255, default: "", null: false
    t.integer  "dj_id",                                       null: false
    t.integer  "radio_id",                                    null: false
    t.text     "description",                    default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "playlist_id"
    t.string   "color"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "social_identities", force: :cascade do |t|
    t.string   "uid",          default: "", null: false
    t.string   "provider",     default: "", null: false
    t.integer  "user_id",                   null: false
    t.string   "token"
    t.string   "string"
    t.string   "token_secret"
    t.string   "name",         default: "", null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "plan_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stripe_customer_token", limit: 255
    t.integer  "user_id",                                           null: false
    t.string   "last_4_digits"
    t.integer  "exp_month"
    t.integer  "exp_year"
    t.boolean  "on_trial",                          default: false, null: false
    t.datetime "trial_ends_at"
    t.boolean  "canceled",                          default: false, null: false
  end

  create_table "track_labels", force: :cascade do |t|
    t.integer  "label_id",   null: false
    t.integer  "track_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tracks", force: :cascade do |t|
    t.string   "audio_file_name",       limit: 255
    t.integer  "radio_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description",                       default: "", null: false
    t.string   "artist"
    t.string   "title"
    t.string   "album"
    t.integer  "year"
    t.integer  "track"
    t.integer  "filesize"
    t.integer  "tag_processing_status",             default: 0,  null: false
  end

  create_table "user_radios", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "radio_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role",                   limit: 255
    t.string   "username",               limit: 255, default: "", null: false
    t.string   "time_zone"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
