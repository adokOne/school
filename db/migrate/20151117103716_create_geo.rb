class CreateGeo < ActiveRecord::Migration
  def change
  create_table "cities", force: :cascade do |t|
    t.string   "code",              limit: 255
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

    t.string   "logo_file_name",    limit: 255
    t.string   "logo_content_type", limit: 255
    t.integer  "logo_file_size",    limit: 4
    t.datetime "logo_updated_at"
    t.boolean  "show_as_popular",   limit: 1
    t.string   "seo_name",          limit: 255
    t.text     "desc_en",           limit: 4294967295
    t.text     "desc_uk",           limit: 4294967295
    t.text     "desc_ru",           limit: 4294967295
    t.string   "meta_title_ru",     limit: 255,        default: ""
    t.text     "meta_desc_ru",      limit: 65535
    t.text     "meta_keys_ru",      limit: 65535
    t.string   "meta_title_en",     limit: 255,        default: ""
    t.text     "meta_desc_en",      limit: 65535
    t.text     "meta_keys_en",      limit: 65535
    t.string   "meta_title_uk",     limit: 255,        default: ""
    t.text     "meta_desc_uk",      limit: 65535
    t.text     "meta_keys_uk",      limit: 65535
    t.boolean  "meta_is_generated", limit: 1,          default: true
  end

  add_index "cities", ["code"], name: "index_cities_on_code", using: :btree
  add_index "cities", ["continent_id"], name: "index_cities_on_continent_id", using: :btree
  add_index "cities", ["country_id"], name: "index_cities_on_country_id", using: :btree
  add_index "cities", ["show_on_search"], name: "index_cities_on_show_on_search", using: :btree

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
    t.string   "flag_file_name",    limit: 255
    t.string   "flag_content_type", limit: 255
    t.integer  "flag_file_size",    limit: 4
    t.datetime "flag_updated_at"
    t.text     "g_map_url",         limit: 65535
    t.string   "seo_name",          limit: 255
    t.text     "desc_en",           limit: 4294967295
    t.text     "desc_uk",           limit: 4294967295
    t.string   "meta_title_ru",     limit: 255,        default: ""
    t.text     "meta_desc_ru",      limit: 65535
    t.text     "meta_keys_ru",      limit: 65535
    t.string   "meta_title_en",     limit: 255,        default: ""
    t.text     "meta_desc_en",      limit: 65535
    t.text     "meta_keys_en",      limit: 65535
    t.string   "meta_title_uk",     limit: 255,        default: ""
    t.text     "meta_desc_uk",      limit: 65535
    t.text     "meta_keys_uk",      limit: 65535
    t.boolean  "meta_is_generated", limit: 1,          default: true
  end

  add_index "countries", ["code"], name: "index_countries_on_code", using: :btree
  add_index "countries", ["continent_id"], name: "index_countries_on_continent_id", using: :btree
  end
end
