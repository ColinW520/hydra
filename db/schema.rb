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

ActiveRecord::Schema.define(version: 20171002041713) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_stat_statements"

  create_table "ahoy_events", force: :cascade do |t|
    t.integer  "visit_id"
    t.integer  "user_id"
    t.string   "name"
    t.jsonb    "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time", using: :btree
    t.index ["user_id", "name"], name: "index_ahoy_events_on_user_id_and_name", using: :btree
    t.index ["visit_id", "name"], name: "index_ahoy_events_on_visit_id_and_name", using: :btree
  end

  create_table "ahoy_messages", force: :cascade do |t|
    t.string   "token"
    t.text     "to"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "mailer"
    t.text     "subject"
    t.text     "content"
    t.string   "utm_source"
    t.string   "utm_medium"
    t.string   "utm_term"
    t.string   "utm_content"
    t.string   "utm_campaign"
    t.datetime "sent_at"
    t.datetime "opened_at"
    t.datetime "clicked_at"
    t.index ["token"], name: "index_ahoy_messages_on_token", using: :btree
    t.index ["user_id", "user_type"], name: "index_ahoy_messages_on_user_id_and_user_type", using: :btree
  end

  create_table "billing_methods", force: :cascade do |t|
    t.integer  "organization_id"
    t.string   "nickname"
    t.string   "stripe_token_id"
    t.integer  "created_by"
    t.datetime "removed_at"
    t.datetime "last_succeeded_at"
    t.datetime "last_failed_at"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "removed_by"
    t.index ["organization_id"], name: "index_billing_methods_on_organization_id", using: :btree
  end

  create_table "blazer_audits", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "query_id"
    t.text     "statement"
    t.string   "data_source"
    t.datetime "created_at"
    t.index ["query_id"], name: "index_blazer_audits_on_query_id", using: :btree
    t.index ["user_id"], name: "index_blazer_audits_on_user_id", using: :btree
  end

  create_table "blazer_checks", force: :cascade do |t|
    t.integer  "creator_id"
    t.integer  "query_id"
    t.string   "state"
    t.string   "schedule"
    t.text     "emails"
    t.string   "check_type"
    t.text     "message"
    t.datetime "last_run_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["creator_id"], name: "index_blazer_checks_on_creator_id", using: :btree
    t.index ["query_id"], name: "index_blazer_checks_on_query_id", using: :btree
  end

  create_table "blazer_dashboard_queries", force: :cascade do |t|
    t.integer  "dashboard_id"
    t.integer  "query_id"
    t.integer  "position"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["dashboard_id"], name: "index_blazer_dashboard_queries_on_dashboard_id", using: :btree
    t.index ["query_id"], name: "index_blazer_dashboard_queries_on_query_id", using: :btree
  end

  create_table "blazer_dashboards", force: :cascade do |t|
    t.integer  "creator_id"
    t.text     "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_dashboards_on_creator_id", using: :btree
  end

  create_table "blazer_queries", force: :cascade do |t|
    t.integer  "creator_id"
    t.string   "name"
    t.text     "description"
    t.text     "statement"
    t.string   "data_source"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["creator_id"], name: "index_blazer_queries_on_creator_id", using: :btree
  end

  create_table "call_logs", force: :cascade do |t|
    t.integer  "line_id"
    t.string   "organization_id"
    t.string   "contact_id"
    t.boolean  "forwarded"
    t.string   "forwarded_to"
    t.string   "direction"
    t.string   "account_sid"
    t.string   "call_sid"
    t.string   "call_status"
    t.string   "called"
    t.string   "called_state"
    t.string   "called_zip"
    t.string   "called_city"
    t.string   "called_country"
    t.string   "caller_country"
    t.string   "caller_state"
    t.string   "caller_zip"
    t.string   "caller_city"
    t.string   "caller"
    t.string   "to"
    t.string   "to_zip"
    t.string   "to_state"
    t.string   "to_city"
    t.string   "to_country"
    t.string   "from"
    t.string   "from_country"
    t.string   "from_city"
    t.string   "from_zip"
    t.string   "from_state"
    t.string   "api_version"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.decimal  "price_in_cents",      precision: 8, scale: 5
    t.integer  "duration_in_seconds"
    t.string   "answered_by"
  end

  create_table "contacts", force: :cascade do |t|
    t.integer  "organization_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "mobile_phone"
    t.string   "title"
    t.string   "preferred_language"
    t.datetime "birthday"
    t.string   "address_line"
    t.string   "address_city"
    t.string   "address_state"
    t.string   "address_zip"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.datetime "last_messaged_at"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.boolean  "phone_is_valid_for_sms"
    t.boolean  "is_active",              default: true
    t.string   "internal_identifier"
    t.datetime "removed_at"
    t.string   "removed_by"
    t.datetime "opted_out_at"
    t.index ["internal_identifier"], name: "index_contacts_on_internal_identifier", using: :btree
    t.index ["organization_id"], name: "index_contacts_on_organization_id", using: :btree
  end

  create_table "coupons", force: :cascade do |t|
    t.string   "stripe_id"
    t.string   "code"
    t.integer  "percent_off"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "feed_items", force: :cascade do |t|
    t.integer  "organization_id"
    t.integer  "user_id"
    t.string   "parent_type"
    t.integer  "parent_id"
    t.string   "phrase"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "action_type"
    t.index ["organization_id"], name: "index_feed_items_on_organization_id", using: :btree
    t.index ["parent_type", "parent_id"], name: "index_feed_items_on_parent_type_and_parent_id", using: :btree
    t.index ["user_id"], name: "index_feed_items_on_user_id", using: :btree
  end

  create_table "imports", force: :cascade do |t|
    t.integer  "organization_id"
    t.string   "type"
    t.string   "status"
    t.string   "message"
    t.integer  "created_by"
    t.datetime "completed_at"
    t.boolean  "is_enqueued"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "datafile_file_name"
    t.string   "datafile_content_type"
    t.integer  "datafile_file_size"
    t.datetime "datafile_updated_at"
    t.index ["organization_id"], name: "index_imports_on_organization_id", using: :btree
  end

  create_table "lines", force: :cascade do |t|
    t.integer  "organization_id"
    t.integer  "user_id"
    t.string   "twilio_id"
    t.string   "number"
    t.string   "name"
    t.string   "voice_forwarding_number"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.datetime "released_at"
    t.string   "released_by"
    t.integer  "errors_count"
    t.string   "latest_error_message"
    t.string   "voice_url"
    t.string   "sms_url"
    t.string   "sms_auto_response_text"
    t.string   "voice_auto_response"
    t.boolean  "reject_voice_calls",      default: false
    t.index ["organization_id"], name: "index_lines_on_organization_id", using: :btree
    t.index ["user_id"], name: "index_lines_on_user_id", using: :btree
  end

  create_table "media_items", force: :cascade do |t|
    t.integer  "message_request_id"
    t.string   "name"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.index ["message_request_id"], name: "index_media_items_on_message_request_id", using: :btree
  end

  create_table "media_links", force: :cascade do |t|
    t.integer  "message_id"
    t.string   "link"
    t.string   "direction"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id"], name: "index_media_links_on_message_id", using: :btree
  end

  create_table "message_requests", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "organization_id"
    t.string   "body"
    t.integer  "recipients_count"
    t.datetime "processed_at"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "line_id"
    t.text     "filter_query"
    t.datetime "send_at"
    t.index ["line_id"], name: "index_message_requests_on_line_id", using: :btree
    t.index ["organization_id"], name: "index_message_requests_on_organization_id", using: :btree
    t.index ["user_id"], name: "index_message_requests_on_user_id", using: :btree
  end

  create_table "messages", force: :cascade do |t|
    t.string   "twilio_sid"
    t.string   "message_request_id"
    t.string   "line_id"
    t.string   "status"
    t.string   "direction"
    t.datetime "sent_at"
    t.string   "to"
    t.string   "from"
    t.string   "body"
    t.string   "error_message"
    t.decimal  "price_in_cents",     precision: 8, scale: 5
    t.string   "account_sid"
    t.string   "organization_id"
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
    t.string   "in_response_to"
    t.integer  "contact_id"
    t.string   "from_zip"
    t.string   "from_city"
    t.string   "from_country"
    t.string   "from_state"
    t.integer  "num_segments"
    t.integer  "num_media"
    t.string   "sms_sid"
    t.datetime "received_at"
    t.string   "forwarded_to"
    t.boolean  "alerts_sent",                                default: false
    t.index ["contact_id"], name: "index_messages_on_contact_id", using: :btree
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "email_domain"
    t.datetime "removed_at"
    t.integer  "removed_by"
    t.integer  "created_by"
    t.string   "slug"
    t.integer  "updated_by"
    t.string   "stripe_token_id"
    t.string   "stripe_customer_id"
    t.string   "twilio_auth_id"
    t.string   "preferred_area_code"
    t.index ["slug"], name: "index_organizations_on_slug", unique: true, using: :btree
  end

  create_table "plans", force: :cascade do |t|
    t.string   "stripe_id"
    t.string   "name"
    t.integer  "amount_in_cents"
    t.integer  "trial_period_days"
    t.string   "statement_descriptor"
    t.boolean  "can_add_users"
    t.boolean  "can_send_mms"
    t.boolean  "can_schedule_messages"
    t.boolean  "can_upload_contacts"
    t.boolean  "can_add_lines"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "questions", force: :cascade do |t|
    t.string   "text"
    t.text     "answer"
    t.integer  "display_order"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
    t.index ["updated_at"], name: "index_sessions_on_updated_at", using: :btree
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "organization_id"
    t.string   "stripe_plan_id"
    t.string   "stripe_customer_id"
    t.integer  "created_by"
    t.integer  "canceled_by"
    t.string   "coupon_code"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.datetime "ends_at"
    t.string   "stripe_id"
    t.datetime "canceled_at"
    t.boolean  "spam_agreed",        default: false
    t.boolean  "terms_agreed",       default: false
    t.string   "signer_name"
    t.string   "current_status"
    t.index ["organization_id"], name: "index_subscriptions_on_organization_id", using: :btree
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.string   "taggable_type"
    t.integer  "taggable_id"
    t.string   "tagger_type"
    t.integer  "tagger_id"
    t.string   "context",       limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context", using: :btree
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
    t.index ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy", using: :btree
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id", using: :btree
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type", using: :btree
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type", using: :btree
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id", using: :btree
  end

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true, using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",                           null: false
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,                            null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
    t.boolean  "admin_role",             default: false
    t.integer  "organization_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invitations_count",      default: 0
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.datetime "deleted_at"
    t.string   "mobile_phone"
    t.string   "timezone",               default: "Pacific Time (US & Canada)"
    t.boolean  "mobile_phone_validated"
    t.boolean  "is_super_user",          default: false
    t.boolean  "notify_instantly",       default: false
    t.boolean  "summarize_daily",        default: false
    t.boolean  "summarize_weekly",       default: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
    t.index ["organization_id"], name: "index_users_on_organization_id", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "visits", force: :cascade do |t|
    t.string   "visit_token"
    t.string   "visitor_token"
    t.string   "ip"
    t.text     "user_agent"
    t.text     "referrer"
    t.text     "landing_page"
    t.integer  "user_id"
    t.string   "referring_domain"
    t.string   "search_keyword"
    t.string   "browser"
    t.string   "os"
    t.string   "device_type"
    t.integer  "screen_height"
    t.integer  "screen_width"
    t.string   "country"
    t.string   "region"
    t.string   "city"
    t.string   "postal_code"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.string   "utm_source"
    t.string   "utm_medium"
    t.string   "utm_term"
    t.string   "utm_content"
    t.string   "utm_campaign"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_visits_on_user_id", using: :btree
    t.index ["visit_token"], name: "index_visits_on_visit_token", unique: true, using: :btree
  end

  add_foreign_key "billing_methods", "organizations"
  add_foreign_key "contacts", "organizations"
  add_foreign_key "feed_items", "organizations"
  add_foreign_key "feed_items", "users"
  add_foreign_key "imports", "organizations"
  add_foreign_key "lines", "organizations"
  add_foreign_key "lines", "users"
  add_foreign_key "media_items", "message_requests"
  add_foreign_key "media_links", "messages"
  add_foreign_key "message_requests", "lines"
  add_foreign_key "message_requests", "organizations"
  add_foreign_key "message_requests", "users"
  add_foreign_key "messages", "contacts"
  add_foreign_key "subscriptions", "organizations"
  add_foreign_key "users", "organizations"
end
