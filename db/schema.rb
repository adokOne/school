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

ActiveRecord::Schema.define(version: 20151228133737) do

  create_table "b1_admin_modules", force: :cascade do |t|
    t.string   "ico",          limit: 20, default: "fa-file", null: false
    t.integer  "parent_id",    limit: 4,  default: 0,         null: false
    t.string   "name_uk",      limit: 50,                     null: false
    t.string   "name_ru",      limit: 50,                     null: false
    t.string   "controller",   limit: 50,                     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",     limit: 4,  default: 0
    t.boolean  "hidden",       limit: 1,  default: false
    t.boolean  "show_in_list", limit: 1,  default: true
  end

  add_index "b1_admin_modules", ["parent_id"], name: "index_b1_admin_modules_on_parent_id", using: :btree

  create_table "b1_admin_modules_roles", id: false, force: :cascade do |t|
    t.integer "role_id",   limit: 4, null: false
    t.integer "module_id", limit: 4, null: false
  end

  add_index "b1_admin_modules_roles", ["module_id", "role_id"], name: "b1_admin_modules_roles_index", unique: true, using: :btree

  create_table "b1_admin_permissions", force: :cascade do |t|
    t.string   "desc_uk",    limit: 50,  null: false
    t.string   "desc_ru",    limit: 50,  null: false
    t.integer  "module_id",  limit: 4
    t.string   "action",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "b1_admin_permissions", ["module_id"], name: "index_b1_admin_permissions_on_module_id", using: :btree

  create_table "b1_admin_permissions_roles", id: false, force: :cascade do |t|
    t.integer "role_id",       limit: 4, null: false
    t.integer "permission_id", limit: 4, null: false
  end

  add_index "b1_admin_permissions_roles", ["permission_id", "role_id"], name: "b1_admin_permissions_roles_index", unique: true, using: :btree

  create_table "b1_admin_roles", force: :cascade do |t|
    t.string   "name",       limit: 30, null: false
    t.string   "desc_uk",    limit: 50, null: false
    t.string   "desc_ru",    limit: 50, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "b1_admin_roles_users", id: false, force: :cascade do |t|
    t.integer "role_id", limit: 4, null: false
    t.integer "user_id", limit: 4, null: false
  end

  add_index "b1_admin_roles_users", ["role_id", "user_id"], name: "b1_admin_roles_users_index", unique: true, using: :btree

  create_table "b1_admin_users", force: :cascade do |t|
    t.string   "name",                    limit: 255
    t.string   "email",                   limit: 255,                 null: false
    t.string   "phone",                   limit: 255
    t.string   "position",                limit: 255
    t.string   "password_digest",         limit: 255,                 null: false
    t.boolean  "blocked",                 limit: 1,   default: false
    t.datetime "blocked_until"
    t.integer  "wrong_password_attempts", limit: 4,   default: 0
    t.integer  "signins_count",           limit: 4,   default: 0
    t.boolean  "active",                  limit: 1,   default: true
    t.string   "avatar_file_name",        limit: 255
    t.string   "avatar_content_type",     limit: 255
    t.integer  "avatar_file_size",        limit: 4
    t.datetime "avatar_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "b1_admin_users", ["email", "blocked", "active"], name: "index_b1_admin_users_on_email_and_blocked_and_active", using: :btree

  create_table "blog_pages", force: :cascade do |t|
    t.string   "seo_name",          limit: 255,                       null: false
    t.text     "desc",              limit: 4294967295
    t.text     "anons",             limit: 65535
    t.string   "title",             limit: 255,                       null: false
    t.boolean  "active",            limit: 1,          default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name",    limit: 255
    t.string   "logo_content_type", limit: 255
    t.integer  "logo_file_size",    limit: 4
    t.datetime "logo_updated_at"
    t.integer  "old_id",            limit: 4
    t.integer  "admin_id",          limit: 4
    t.integer  "admin_update_id",   limit: 4
    t.string   "slug",              limit: 255
  end

  create_table "categories", force: :cascade do |t|
    t.string   "title_ru",             limit: 255,                       null: false
    t.integer  "parent_id",            limit: 4,          default: 0,    null: false
    t.string   "seo_name",             limit: 255,                       null: false
    t.integer  "position",             limit: 4,          default: 0,    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "desc_ru",              limit: 4294967295
    t.string   "logo_file_name",       limit: 255
    t.string   "logo_content_type",    limit: 255
    t.integer  "logo_file_size",       limit: 4
    t.datetime "logo_updated_at"
    t.boolean  "meta_is_generated",    limit: 1,          default: true
    t.text     "meta_desc_ru",         limit: 65535
    t.text     "meta_desc_uk",         limit: 65535
    t.text     "meta_desc_en",         limit: 65535
    t.text     "meta_keys_ru",         limit: 65535
    t.text     "meta_keys_uk",         limit: 65535
    t.text     "meta_keys_en",         limit: 65535
    t.string   "meta_title_ru",        limit: 255
    t.string   "meta_title_uk",        limit: 255
    t.string   "meta_title_en",        limit: 255
    t.text     "desc_uk",              limit: 4294967295
    t.text     "desc_en",              limit: 4294967295
    t.string   "title_en",             limit: 255
    t.string   "title_uk",             limit: 255
    t.integer  "old_id",               limit: 4
    t.integer  "old_parent",           limit: 4
    t.text     "city_seo_template_ru", limit: 65535
    t.text     "city_seo_template_en", limit: 65535
    t.text     "city_seo_template_uk", limit: 65535
  end

  add_index "categories", ["parent_id"], name: "index_categories_on_parent_id", using: :btree
  add_index "categories", ["position"], name: "index_categories_on_position", using: :btree
  add_index "categories", ["seo_name"], name: "index_categories_on_seo_name", using: :btree

  create_table "categories_pages", force: :cascade do |t|
    t.integer "category_id", limit: 4
    t.integer "page_id",     limit: 4
  end

  create_table "category_aliases", force: :cascade do |t|
    t.integer "category_id", limit: 4
    t.string  "seo_name",    limit: 255
  end

  create_table "cities", force: :cascade do |t|
    t.float    "lat",               limit: 24,         default: 0.0,  null: false
    t.float    "lng",               limit: 24,         default: 0.0,  null: false
    t.string   "name_ru",           limit: 255,        default: ""
    t.string   "name_en",           limit: 255,        default: ""
    t.string   "name_uk",           limit: 255,        default: ""
    t.string   "time_zone",         limit: 255
    t.boolean  "show_on_search",    limit: 1,          default: true
    t.integer  "country_id",        limit: 4,          default: 0,    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "continent_id",      limit: 4,          default: 0
    t.text     "desc_ru",           limit: 4294967295
    t.string   "logo_file_name",    limit: 255
    t.string   "logo_content_type", limit: 255
    t.integer  "logo_file_size",    limit: 4
    t.datetime "logo_updated_at"
    t.boolean  "show_as_popular",   limit: 1
    t.string   "seo_name",          limit: 255
    t.text     "desc_en",           limit: 4294967295
    t.string   "meta_title_ru",     limit: 255,        default: ""
    t.text     "meta_desc_ru",      limit: 65535
    t.text     "meta_keys_ru",      limit: 65535
    t.string   "meta_title_en",     limit: 255,        default: ""
    t.text     "meta_desc_en",      limit: 65535
    t.text     "meta_keys_en",      limit: 65535
    t.boolean  "meta_is_generated", limit: 1,          default: true
    t.text     "desc_uk",           limit: 4294967295
    t.string   "meta_title_uk",     limit: 255
    t.text     "meta_desc_uk",      limit: 65535
    t.string   "meta_keys_uk",      limit: 255
    t.string   "anons_ru",          limit: 255
    t.string   "anons_uk",          limit: 255
    t.string   "anons_en",          limit: 255
    t.string   "seo_text_ru",       limit: 255
    t.string   "seo_text_uk",       limit: 255
    t.string   "seo_text_en",       limit: 255
  end

  add_index "cities", ["continent_id"], name: "index_cities_on_continent_id", using: :btree
  add_index "cities", ["country_id"], name: "index_cities_on_country_id", using: :btree
  add_index "cities", ["show_on_search"], name: "index_cities_on_show_on_search", using: :btree

  create_table "cities_pages", force: :cascade do |t|
    t.integer "city_id", limit: 4
    t.integer "page_id", limit: 4
  end

  create_table "city_aliases", force: :cascade do |t|
    t.integer "city_id",  limit: 4
    t.string  "seo_name", limit: 255
  end

  create_table "contacts", force: :cascade do |t|
    t.string  "contact_type", limit: 255, null: false
    t.string  "value",        limit: 255
    t.integer "user_id",      limit: 4,   null: false
  end

  add_index "contacts", ["user_id"], name: "index_contacts_on_user_id", using: :btree

  create_table "continents", force: :cascade do |t|
    t.string   "seo_name",   limit: 255,                      null: false
    t.string   "name_en",    limit: 255,        default: "-", null: false
    t.text     "desc_en",    limit: 4294967295
    t.string   "name_ru",    limit: 255,        default: "-", null: false
    t.text     "desc_ru",    limit: 4294967295
    t.string   "name_uk",    limit: 255,        default: "-", null: false
    t.text     "desc_uk",    limit: 4294967295
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "continents", ["seo_name"], name: "index_continents_on_seo_name", using: :btree

  create_table "countries", force: :cascade do |t|
    t.string   "code",              limit: 255,                       null: false
    t.string   "old_code",          limit: 255,                       null: false
    t.string   "name_ru",           limit: 255
    t.string   "name_en",           limit: 255
    t.string   "name_uk",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "continent_id",      limit: 4,          default: 0
    t.text     "desc_ru",           limit: 4294967295
    t.string   "flag_file_name",    limit: 255
    t.string   "flag_content_type", limit: 255
    t.integer  "flag_file_size",    limit: 4
    t.datetime "flag_updated_at"
    t.text     "g_map_url",         limit: 65535
    t.string   "seo_name",          limit: 255
    t.text     "desc_en",           limit: 4294967295
    t.string   "meta_title_ru",     limit: 255,        default: ""
    t.text     "meta_desc_ru",      limit: 65535
    t.text     "meta_keys_ru",      limit: 65535
    t.string   "meta_title_en",     limit: 255,        default: ""
    t.text     "meta_desc_en",      limit: 65535
    t.text     "meta_keys_en",      limit: 65535
    t.boolean  "meta_is_generated", limit: 1,          default: true
    t.text     "desc_uk",           limit: 4294967295
    t.string   "meta_title_uk",     limit: 255
    t.text     "meta_desc_uk",      limit: 4294967295
    t.string   "meta_keys_uk",      limit: 255
  end

  add_index "countries", ["code"], name: "index_countries_on_code", using: :btree
  add_index "countries", ["continent_id"], name: "index_countries_on_continent_id", using: :btree

  create_table "feedbacks", force: :cascade do |t|
    t.string  "name",      limit: 255,   default: ""
    t.string  "email",     limit: 255,   default: ""
    t.string  "phone",     limit: 255,   default: ""
    t.text    "message",   limit: 65535
    t.integer "admin_id",  limit: 4
    t.boolean "processed", limit: 1,     default: false
  end

  create_table "impressions", force: :cascade do |t|
    t.string   "impressionable_type", limit: 255
    t.integer  "impressionable_id",   limit: 4
    t.integer  "user_id",             limit: 4
    t.string   "controller_name",     limit: 255
    t.string   "action_name",         limit: 255
    t.string   "view_name",           limit: 255
    t.string   "request_hash",        limit: 255
    t.string   "ip_address",          limit: 255
    t.string   "session_hash",        limit: 255
    t.text     "message",             limit: 65535
    t.text     "referrer",            limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "impressions", ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index", length: {"impressionable_type"=>nil, "message"=>255, "impressionable_id"=>nil}, using: :btree
  add_index "impressions", ["user_id"], name: "index_impressions_on_user_id", using: :btree

  create_table "members", force: :cascade do |t|
    t.string   "name",              limit: 255,   default: "", null: false
    t.text     "desc",              limit: 65535,              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name",    limit: 255
    t.string   "logo_content_type", limit: 255
    t.integer  "logo_file_size",    limit: 4
    t.datetime "logo_updated_at"
  end

  create_table "messages", force: :cascade do |t|
    t.string   "topic",                      limit: 255
    t.text     "body",                       limit: 65535
    t.integer  "received_messageable_id",    limit: 4
    t.string   "received_messageable_type",  limit: 255
    t.integer  "sent_messageable_id",        limit: 4
    t.string   "sent_messageable_type",      limit: 255
    t.boolean  "opened",                     limit: 1,     default: false
    t.boolean  "recipient_delete",           limit: 1,     default: false
    t.boolean  "sender_delete",              limit: 1,     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry",                   limit: 255
    t.boolean  "recipient_permanent_delete", limit: 1,     default: false
    t.boolean  "sender_permanent_delete",    limit: 1,     default: false
  end

  add_index "messages", ["ancestry"], name: "index_messages_on_ancestry", using: :btree
  add_index "messages", ["sent_messageable_id", "received_messageable_id"], name: "acts_as_messageable_ids", using: :btree

  create_table "orders", force: :cascade do |t|
    t.integer  "product_id",     limit: 4
    t.integer  "user_id",        limit: 4
    t.integer  "page_id",        limit: 4
    t.integer  "transaction_id", limit: 4
    t.float    "amount",         limit: 24
    t.string   "currency",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",         limit: 4
    t.integer  "admin_id",       limit: 4
    t.date     "start_date"
    t.text     "comment",        limit: 65535
  end

  create_table "pages", force: :cascade do |t|
    t.integer  "category_id",              limit: 4,          default: 0,     null: false
    t.string   "seo_name",                 limit: 255,                        null: false
    t.text     "desc",                     limit: 4294967295
    t.text     "anons",                    limit: 65535
    t.string   "title",                    limit: 255,                        null: false
    t.boolean  "active",                   limit: 1,          default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",                 limit: 4
    t.string   "logo_file_name",           limit: 255
    t.string   "logo_content_type",        limit: 255
    t.integer  "logo_file_size",           limit: 4
    t.datetime "logo_updated_at"
    t.integer  "user_id",                  limit: 4
    t.boolean  "has_adwords",              limit: 1,          default: false
    t.boolean  "in_top",                   limit: 1,          default: false
    t.date     "top_until"
    t.date     "adwords_untilm"
    t.date     "top_set_date"
    t.integer  "city_id",                  limit: 4
    t.integer  "country_id",               limit: 4
    t.boolean  "in_ukraine_top",           limit: 1,          default: false
    t.boolean  "in_state_top",             limit: 1,          default: false
    t.boolean  "in_category_top",          limit: 1,          default: false
    t.date     "ukraine_top_date"
    t.date     "state_top_date"
    t.date     "category_top_date"
    t.boolean  "meta_is_generated",        limit: 1,          default: true
    t.text     "meta_desc",                limit: 65535
    t.text     "meta_keys",                limit: 65535
    t.string   "meta_title",               limit: 255
    t.string   "slug",                     limit: 255
    t.integer  "old_id",                   limit: 4
    t.integer  "admin_id",                 limit: 4
    t.integer  "admin_update_id",          limit: 4
    t.string   "focuskw",                  limit: 255
    t.boolean  "city_is_canonical",        limit: 1,          default: false
    t.boolean  "is_vip_db",                limit: 1,          default: false
    t.boolean  "has_main_top_db",          limit: 1,          default: false
    t.boolean  "has_city_top_db",          limit: 1,          default: false
    t.boolean  "has_category_top_db",      limit: 1,          default: false
    t.date     "is_vip_db_date"
    t.date     "has_main_top_db_date"
    t.date     "has_city_top_db_date"
    t.date     "has_category_top_db_date"
  end

  add_index "pages", ["active"], name: "index_pages_on_active", using: :btree
  add_index "pages", ["category_id"], name: "index_pages_on_category_id", using: :btree
  add_index "pages", ["seo_name"], name: "index_pages_on_seo_name", using: :btree
  add_index "pages", ["user_id"], name: "index_pages_on_user_id", using: :btree

  create_table "partners", force: :cascade do |t|
    t.string   "name",              limit: 255, default: "",   null: false
    t.boolean  "active",            limit: 1,   default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name",    limit: 255
    t.string   "logo_content_type", limit: 255
    t.integer  "logo_file_size",    limit: 4
    t.datetime "logo_updated_at"
  end

  add_index "partners", ["active"], name: "index_partners_on_active", using: :btree

  create_table "photos", force: :cascade do |t|
    t.string   "name",              limit: 255, default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name",    limit: 255
    t.string   "logo_content_type", limit: 255
    t.integer  "logo_file_size",    limit: 4
    t.datetime "logo_updated_at"
  end

  create_table "products", force: :cascade do |t|
    t.string   "name_ru",           limit: 255,      default: "",    null: false
    t.boolean  "active",            limit: 1,        default: true,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name",    limit: 255
    t.string   "logo_content_type", limit: 255
    t.integer  "logo_file_size",    limit: 4
    t.datetime "logo_updated_at"
    t.string   "title",             limit: 255
    t.text     "desc_ru",           limit: 16777215
    t.boolean  "show_in_top",       limit: 1,        default: false
    t.boolean  "has_sale",          limit: 1,        default: false
    t.boolean  "has_second_price",  limit: 1,        default: false
    t.boolean  "is_one_time",       limit: 1,        default: false
    t.float    "price",             limit: 24,       default: 0.0
    t.float    "second_price",      limit: 24,       default: 0.0
    t.float    "sale_price",        limit: 24,       default: 0.0
    t.string   "period",            limit: 255
    t.string   "name_uk",           limit: 255
    t.string   "name_en",           limit: 255
    t.text     "desc_uk",           limit: 16777215
    t.text     "desc_en",           limit: 16777215
    t.text     "anons_en",          limit: 65535
    t.text     "anons_ru",          limit: 65535
    t.text     "anons_uk",          limit: 65535
    t.boolean  "has_vip_status",    limit: 1,        default: false
    t.boolean  "has_category_top",  limit: 1,        default: false
    t.boolean  "has_region_top",    limit: 1,        default: false
    t.boolean  "has_main_top",      limit: 1,        default: false
    t.boolean  "has_adwords_stat",  limit: 1,        default: false
    t.integer  "period_of_service", limit: 4,        default: 0
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "page_id",   limit: 4
    t.integer "rating",    limit: 4
    t.string  "email",     limit: 255
    t.string  "name",      limit: 255
    t.text    "comment",   limit: 65535
    t.boolean "moderated", limit: 1,     default: false
  end

  create_table "signins", force: :cascade do |t|
    t.integer  "signinable_id",   limit: 4,                null: false
    t.string   "signinable_type", limit: 255,              null: false
    t.string   "token",           limit: 255,              null: false
    t.string   "referer",         limit: 255, default: ""
    t.string   "user_agent",      limit: 255, default: ""
    t.string   "ip",              limit: 255,              null: false
    t.datetime "expiration_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "signins", ["signinable_id", "signinable_type"], name: "index_signins_on_signinable_id_and_signinable_type", using: :btree
  add_index "signins", ["token"], name: "index_signins_on_token", using: :btree

  create_table "subscribers", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "email",      limit: 255,                null: false
    t.string   "phone",      limit: 255
    t.boolean  "active",     limit: 1,   default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer  "payment_system", limit: 4
    t.float    "amount",         limit: 24
    t.integer  "user_id",        limit: 4
    t.string   "description",    limit: 255
    t.integer  "product_id",     limit: 4
    t.integer  "status",         limit: 4
    t.string   "tnx_id",         limit: 255,                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "currency",       limit: 255, default: "UAH"
    t.string   "transaction_id", limit: 255
  end

  add_index "transactions", ["tnx_id"], name: "index_transactions_on_tnx_id", unique: true, using: :btree

  create_table "upload_images", force: :cascade do |t|
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "file_file_name",    limit: 255
    t.string   "file_content_type", limit: 255
    t.integer  "file_file_size",    limit: 4
    t.datetime "file_updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                    limit: 255
    t.string   "email",                   limit: 255,                   null: false
    t.string   "password_digest",         limit: 255,                   null: false
    t.boolean  "blocked",                 limit: 1,     default: false
    t.datetime "blocked_until"
    t.integer  "wrong_password_attempts", limit: 4,     default: 0
    t.integer  "signins_count",           limit: 4,     default: 0
    t.boolean  "active",                  limit: 1,     default: true
    t.string   "avatar_file_name",        limit: 255
    t.string   "avatar_content_type",     limit: 255
    t.integer  "avatar_file_size",        limit: 4
    t.datetime "avatar_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "desc",                    limit: 65535
    t.boolean  "is_vip_db",               limit: 1,     default: false
    t.date     "is_vip_db_date"
  end

  create_table "vacancies", force: :cascade do |t|
    t.string   "name",       limit: 255,   default: "",   null: false
    t.text     "desc",       limit: 65535,                null: false
    t.boolean  "active",     limit: 1,     default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      limit: 255,   null: false
    t.integer  "item_id",        limit: 4,     null: false
    t.string   "event",          limit: 255,   null: false
    t.string   "whodunnit",      limit: 255
    t.text     "object",         limit: 65535
    t.datetime "created_at"
    t.text     "object_changes", limit: 65535
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
