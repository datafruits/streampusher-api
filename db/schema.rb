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

ActiveRecord::Schema[7.0].define(version: 2024_08_03_191628) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "blog_post_bodies", id: :serial, force: :cascade do |t|
    t.integer "language", default: 0, null: false
    t.integer "blog_post_id", null: false
    t.string "title", null: false
    t.text "body"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "published", default: false, null: false
    t.index ["blog_post_id"], name: "index_blog_post_bodies_on_blog_post_id"
  end

  create_table "blog_post_images", id: :serial, force: :cascade do |t|
    t.integer "blog_post_body_id"
    t.string "image_file_name"
    t.integer "filesize"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["blog_post_body_id"], name: "index_blog_post_images_on_blog_post_body_id"
  end

  create_table "blog_posts", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "radio_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.datetime "published_at", precision: nil
    t.index ["radio_id"], name: "index_blog_posts_on_radio_id"
    t.index ["user_id"], name: "index_blog_posts_on_user_id"
  end

  create_table "experience_point_awards", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "amount", null: false
    t.integer "award_type", null: false
    t.integer "source_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "source_type"
    t.index ["user_id"], name: "index_experience_point_awards_on_user_id"
  end

  create_table "forum_threads", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["slug"], name: "index_forum_threads_on_slug", unique: true
  end

  create_table "friendly_id_slugs", id: :serial, force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at", precision: nil
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "fruit_summon_entities", force: :cascade do |t|
    t.string "name", null: false
    t.integer "cost", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "fruit_summons", force: :cascade do |t|
    t.bigint "fruit_ticket_transaction_id", null: false
    t.bigint "user_id", null: false
    t.bigint "fruit_summon_entity_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["fruit_summon_entity_id"], name: "index_fruit_summons_on_fruit_summon_entity_id"
    t.index ["fruit_ticket_transaction_id"], name: "index_fruit_summons_on_fruit_ticket_transaction_id"
    t.index ["user_id"], name: "index_fruit_summons_on_user_id"
  end

  create_table "fruit_ticket_transactions", force: :cascade do |t|
    t.integer "transaction_type", null: false
    t.integer "source_id"
    t.integer "amount", default: 0, null: false
    t.integer "from_user_id"
    t.integer "to_user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "host_applications", id: :serial, force: :cascade do |t|
    t.integer "radio_id", null: false
    t.string "email", null: false
    t.string "username", null: false
    t.string "link", null: false
    t.integer "interval", default: 0, null: false
    t.text "desired_time", null: false
    t.string "time_zone", null: false
    t.string "other_comment"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "approved", default: false, null: false
    t.string "homepage_url"
    t.index ["radio_id"], name: "index_host_applications_on_radio_id"
  end

  create_table "labels", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "radio_id", null: false
    t.index ["radio_id"], name: "index_labels_on_radio_id"
  end

  create_table "listens", id: :serial, force: :cascade do |t|
    t.integer "radio_id"
    t.string "ip_address", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "start_at", precision: nil
    t.datetime "end_at", precision: nil
    t.float "lat"
    t.float "lon"
    t.integer "icecast_listener_id", null: false
    t.string "user_agent"
    t.string "referer"
    t.string "country"
    t.string "address"
    t.index ["radio_id"], name: "index_listens_on_radio_id"
  end

  create_table "microtexts", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "radio_id", null: false
    t.string "content", null: false
    t.boolean "approved", default: false, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "archived", default: false, null: false
    t.index ["radio_id"], name: "index_microtexts_on_radio_id"
    t.index ["user_id"], name: "index_microtexts_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "notification_type", null: false
    t.boolean "send_to_chat", default: false, null: false
    t.boolean "send_to_user", default: true, null: false
    t.integer "source_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "message", null: false
    t.string "source_type"
    t.boolean "read", default: false, null: false
    t.string "url"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "plans", id: :serial, force: :cascade do |t|
    t.decimal "price"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "name", default: "", null: false
  end

  create_table "playlist_tracks", id: :serial, force: :cascade do |t|
    t.integer "track_id", null: false
    t.integer "playlist_id", null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "position"
    t.datetime "podcast_published_date", precision: nil
    t.index ["playlist_id"], name: "index_playlist_tracks_on_playlist_id"
    t.index ["track_id"], name: "index_playlist_tracks_on_track_id"
  end

  create_table "playlists", id: :serial, force: :cascade do |t|
    t.integer "radio_id", null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "name", limit: 255
    t.integer "interpolated_playlist_id"
    t.integer "interpolated_playlist_track_play_count"
    t.integer "interpolated_playlist_track_interval_count"
    t.boolean "interpolated_playlist_enabled", default: false, null: false
    t.boolean "no_cue_out", default: true, null: false
    t.boolean "shuffle", default: false, null: false
    t.integer "user_id"
    t.boolean "repeat", default: false, null: false
    t.index ["interpolated_playlist_id"], name: "index_playlists_on_interpolated_playlist_id"
    t.index ["radio_id"], name: "index_playlists_on_radio_id"
    t.index ["user_id"], name: "index_playlists_on_user_id"
  end

  create_table "podcasts", id: :serial, force: :cascade do |t|
    t.integer "radio_id", null: false
    t.string "title"
    t.string "link"
    t.string "description"
    t.datetime "last_build_date", precision: nil
    t.string "itunes_summary"
    t.string "itunes_name"
    t.string "itunes_email"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "name", default: "", null: false
    t.integer "playlist_id"
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at", precision: nil
    t.string "extra_tags"
    t.index ["playlist_id"], name: "index_podcasts_on_playlist_id"
    t.index ["radio_id"], name: "index_podcasts_on_radio_id"
  end

  create_table "posts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "postable_type", null: false
    t.bigint "postable_id", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["postable_type", "postable_id"], name: "index_posts_on_postable"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "radios", id: :serial, force: :cascade do |t|
    t.string "icecast_container_id", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "name", limit: 255, default: "", null: false
    t.string "liquidsoap_container_id", limit: 255
    t.integer "default_playlist_id"
    t.boolean "enabled", default: true, null: false
    t.boolean "vj_enabled", default: false, null: false
    t.boolean "podcasts_enabled", default: false, null: false
    t.boolean "stats_enabled", default: false, null: false
    t.string "tunein_partner_id"
    t.string "tunein_partner_key"
    t.string "tunein_station_id"
    t.boolean "tunein_metadata_updates_enabled", default: false, null: false
    t.boolean "social_identities_enabled", default: false, null: false
    t.string "container_name", null: false
    t.boolean "schedule_monitor_enabled", default: false, null: false
    t.string "show_share_url"
    t.integer "port_number"
    t.string "docker_image_name", default: "", null: false
    t.index ["default_playlist_id"], name: "index_radios_on_default_playlist_id"
  end

  create_table "recordings", id: :serial, force: :cascade do |t|
    t.integer "radio_id", null: false
    t.integer "dj_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "path"
    t.integer "processing_status", default: 0, null: false
    t.integer "track_id"
    t.datetime "file_created_at", precision: nil
    t.index ["dj_id"], name: "index_recordings_on_dj_id"
    t.index ["radio_id"], name: "index_recordings_on_radio_id"
    t.index ["track_id"], name: "index_recordings_on_track_id"
  end

  create_table "scheduled_show_favorites", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "scheduled_show_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["scheduled_show_id"], name: "index_scheduled_show_favorites_on_scheduled_show_id"
    t.index ["user_id", "scheduled_show_id"], name: "index_scheduled_show_favorites_on_user_id_and_scheduled_show_id", unique: true
    t.index ["user_id"], name: "index_scheduled_show_favorites_on_user_id"
  end

  create_table "scheduled_show_labels", id: :serial, force: :cascade do |t|
    t.integer "label_id"
    t.integer "scheduled_show_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["label_id"], name: "index_scheduled_show_labels_on_label_id"
    t.index ["scheduled_show_id", "label_id"], name: "index_scheduled_show_labels_on_scheduled_show_id_and_label_id", unique: true
    t.index ["scheduled_show_id"], name: "index_scheduled_show_labels_on_scheduled_show_id"
  end

  create_table "scheduled_show_performers", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "scheduled_show_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["scheduled_show_id", "user_id"], name: "ssp_ssid_uid"
    t.index ["scheduled_show_id"], name: "index_scheduled_show_performers_on_scheduled_show_id"
    t.index ["user_id", "scheduled_show_id"], name: "index_scheduled_show_performers_on_uid_and_ssid", unique: true
    t.index ["user_id"], name: "index_scheduled_show_performers_on_user_id"
  end

  create_table "scheduled_shows", id: :serial, force: :cascade do |t|
    t.integer "radio_id", null: false
    t.datetime "start_at", precision: nil, null: false
    t.datetime "end_at", precision: nil, null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.text "description"
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at", precision: nil
    t.integer "recurring_interval", default: 0, null: false
    t.boolean "recurrence", default: false, null: false
    t.integer "recurrant_original_id"
    t.integer "playlist_id"
    t.integer "dj_id"
    t.string "title"
    t.string "time_zone"
    t.string "slug"
    t.boolean "is_guest", default: false, null: false
    t.string "guest", default: "", null: false
    t.boolean "is_live", default: false, null: false
    t.integer "show_series_id"
    t.integer "status", default: 0, null: false
    t.integer "recording_id"
    t.string "youtube_link"
    t.string "mixcloud_link"
    t.string "soundcloud_link"
    t.index ["dj_id"], name: "index_scheduled_shows_on_dj_id"
    t.index ["playlist_id"], name: "index_scheduled_shows_on_playlist_id"
    t.index ["radio_id"], name: "index_scheduled_shows_on_radio_id"
    t.index ["recurrant_original_id"], name: "index_scheduled_shows_on_recurrant_original_id"
    t.index ["slug", "id"], name: "index_scheduled_shows_on_slug_and_id", unique: true
  end

  create_table "show_series", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.string "image_file_name"
    t.integer "image_file_size"
    t.string "image_content_type"
    t.datetime "image_updated_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "recurring_interval", default: 0, null: false
    t.integer "recurring_weekday", default: 0, null: false
    t.integer "recurring_cadence", default: 0
    t.datetime "start_time", precision: nil, null: false
    t.datetime "end_time", precision: nil, null: false
    t.datetime "start_date", precision: nil, null: false
    t.datetime "end_date", precision: nil
    t.string "slug"
    t.integer "status", default: 0, null: false
    t.integer "radio_id", default: 1, null: false
    t.integer "default_playlist_id"
    t.string "time_zone", default: "UTC", null: false
    t.index ["slug"], name: "index_show_series_on_slug", unique: true
  end

  create_table "show_series_hosts", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "show_series_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["show_series_id", "user_id"], name: "index_show_series_hosts_on_show_series_id_and_user_id", unique: true
    t.index ["show_series_id"], name: "index_show_series_hosts_on_show_series_id"
    t.index ["user_id"], name: "index_show_series_hosts_on_user_id"
  end

  create_table "show_series_labels", force: :cascade do |t|
    t.bigint "label_id"
    t.bigint "show_series_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["label_id"], name: "index_show_series_labels_on_label_id"
    t.index ["show_series_id", "label_id"], name: "index_show_series_labels_on_show_series_id_and_label_id", unique: true
    t.index ["show_series_id"], name: "index_show_series_labels_on_show_series_id"
  end

  create_table "shows", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255, default: "", null: false
    t.integer "dj_id", null: false
    t.integer "radio_id", null: false
    t.text "description", default: "", null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "playlist_id"
    t.string "color"
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at", precision: nil
  end

  create_table "shrimpo_entries", force: :cascade do |t|
    t.bigint "shrimpo_id", null: false
    t.bigint "user_id", null: false
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.integer "total_score"
    t.integer "ranking"
    t.index ["shrimpo_id"], name: "index_shrimpo_entries_on_shrimpo_id"
    t.index ["slug"], name: "index_shrimpo_entries_on_slug", unique: true
    t.index ["user_id"], name: "index_shrimpo_entries_on_user_id"
  end

  create_table "shrimpo_votes", force: :cascade do |t|
    t.bigint "shrimpo_voting_category_id"
    t.bigint "shrimpo_entry_id", null: false
    t.bigint "user_id", null: false
    t.integer "score", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shrimpo_entry_id"], name: "index_shrimpo_votes_on_shrimpo_entry_id"
    t.index ["shrimpo_voting_category_id"], name: "index_shrimpo_votes_on_shrimpo_voting_category_id"
    t.index ["user_id", "shrimpo_entry_id"], name: "index_shrimpo_votes_on_user_id_and_shrimpo_entry_id", unique: true
    t.index ["user_id"], name: "index_shrimpo_votes_on_user_id"
  end

  create_table "shrimpo_voting_categories", force: :cascade do |t|
    t.bigint "shrimpo_id", null: false
    t.string "name"
    t.string "emoji"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shrimpo_id"], name: "index_shrimpo_voting_categories_on_shrimpo_id"
  end

  create_table "shrimpos", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.datetime "start_at", precision: nil, null: false
    t.datetime "end_at", precision: nil, null: false
    t.text "rule_pack"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.string "slug"
    t.string "emoji"
    t.datetime "ended_at"
    t.integer "gold_trophy_id"
    t.integer "silver_trophy_id"
    t.integer "bronze_trophy_id"
    t.integer "consolation_trophy_id"
    t.integer "shrimpo_type", default: 0
    t.index ["slug"], name: "index_shrimpos_on_slug", unique: true
    t.index ["user_id"], name: "index_shrimpos_on_user_id"
  end

  create_table "social_identities", id: :serial, force: :cascade do |t|
    t.string "uid", default: "", null: false
    t.string "provider", default: "", null: false
    t.integer "user_id", null: false
    t.string "token"
    t.string "string"
    t.string "token_secret"
    t.string "name", default: "", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id"], name: "index_social_identities_on_user_id"
  end

  create_table "track_favorites", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "track_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["track_id"], name: "index_track_favorites_on_track_id"
    t.index ["user_id", "track_id"], name: "index_track_favorites_on_user_id_and_track_id", unique: true
    t.index ["user_id"], name: "index_track_favorites_on_user_id"
  end

  create_table "track_labels", id: :serial, force: :cascade do |t|
    t.integer "label_id", null: false
    t.integer "track_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["label_id"], name: "index_track_labels_on_label_id"
    t.index ["track_id", "label_id"], name: "index_track_labels_on_track_id_and_label_id", unique: true
    t.index ["track_id"], name: "index_track_labels_on_track_id"
  end

  create_table "tracks", id: :serial, force: :cascade do |t|
    t.string "audio_file_name", limit: 255
    t.integer "radio_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "description", default: "", null: false
    t.string "artist"
    t.string "title"
    t.string "album"
    t.integer "year"
    t.integer "track"
    t.integer "filesize", default: 0, null: false
    t.integer "tag_processing_status", default: 0, null: false
    t.integer "length"
    t.string "artwork_file_name"
    t.string "artwork_content_type"
    t.integer "artwork_file_size"
    t.datetime "artwork_updated_at", precision: nil
    t.integer "mixcloud_upload_status", default: 0, null: false
    t.string "mixcloud_key"
    t.integer "uploaded_by_id"
    t.integer "scheduled_show_id"
    t.integer "soundcloud_upload_status", default: 0, null: false
    t.string "soundcloud_key"
    t.string "youtube_link"
    t.index ["radio_id"], name: "index_tracks_on_radio_id"
    t.index ["scheduled_show_id"], name: "index_tracks_on_scheduled_show_id"
    t.index ["uploaded_by_id"], name: "index_tracks_on_uploaded_by_id"
  end

  create_table "trophies", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trophy_awards", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "trophy_id", null: false
    t.bigint "shrimpo_entry_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shrimpo_entry_id"], name: "index_trophy_awards_on_shrimpo_entry_id"
    t.index ["trophy_id"], name: "index_trophy_awards_on_trophy_id"
    t.index ["user_id"], name: "index_trophy_awards_on_user_id"
  end

  create_table "user_radios", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "radio_id", null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["radio_id"], name: "index_user_radios_on_radio_id"
    t.index ["user_id", "radio_id"], name: "index_user_radios_on_user_id_and_radio_id", unique: true
    t.index ["user_id"], name: "index_user_radios_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "role", limit: 255
    t.string "username", limit: 255, default: "", null: false
    t.string "time_zone"
    t.string "display_name", default: "", null: false
    t.datetime "deleted_at", precision: nil
    t.boolean "enabled", default: true, null: false
    t.string "referer"
    t.text "bio"
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at", precision: nil
    t.boolean "profile_publish", default: false, null: false
    t.integer "style", default: 0, null: false
    t.string "pronouns", default: "", null: false
    t.string "homepage"
    t.integer "fruit_ticket_balance", default: 0, null: false
    t.integer "experience_points", default: 0, null: false
    t.integer "level", default: 0, null: false
    t.string "stream_key"
    t.string "stream_key_digest"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at", precision: nil
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "wiki_page_edits", force: :cascade do |t|
    t.string "title", null: false
    t.text "body", null: false
    t.bigint "user_id", null: false
    t.bigint "wiki_page_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "summary"
    t.index ["user_id"], name: "index_wiki_page_edits_on_user_id"
    t.index ["wiki_page_id"], name: "index_wiki_page_edits_on_wiki_page_id"
  end

  create_table "wiki_pages", force: :cascade do |t|
    t.string "title", null: false
    t.text "body", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "slug"
    t.datetime "deleted_at", precision: nil
    t.index ["slug"], name: "index_wiki_pages_on_slug", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "blog_post_images", "blog_post_bodies"
  add_foreign_key "scheduled_show_labels", "labels"
  add_foreign_key "scheduled_show_labels", "scheduled_shows"
  add_foreign_key "show_series_hosts", "show_series"
  add_foreign_key "show_series_hosts", "users"
  add_foreign_key "show_series_labels", "labels"
  add_foreign_key "show_series_labels", "show_series"
end
