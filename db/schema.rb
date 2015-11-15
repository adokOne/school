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

ActiveRecord::Schema.define(version: 20151115120319) do

  create_table "addresses", force: :cascade do |t|
    t.string   "name",       limit: 255, default: "",    null: false
    t.string   "email",      limit: 255, default: "",    null: false
    t.string   "phones",     limit: 255, default: "",    null: false
    t.boolean  "active",     limit: 1,   default: true,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title",      limit: 255, default: ""
    t.boolean  "is_main",    limit: 1,   default: false
  end

  add_index "addresses", ["active"], name: "index_addresses_on_active", using: :btree

  create_table "b1_admin_modules", force: :cascade do |t|
    t.string   "ico",          limit: 20, default: "fa-file", null: false
    t.integer  "parent_id",    limit: 4,  default: 0,         null: false
    t.string   "name_uk",      limit: 50,                     null: false
    t.string   "name_en",      limit: 50,                     null: false
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
    t.string   "desc_en",    limit: 50,  null: false
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
    t.string   "desc_en",    limit: 50, null: false
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
    t.string   "hotelier_id",             limit: 255
    t.string   "contract_owner_id",       limit: 255
  end

  add_index "b1_admin_users", ["email", "blocked", "active"], name: "index_b1_admin_users_on_email_and_blocked_and_active", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "title",       limit: 255,                    null: false
    t.integer  "parent_id",   limit: 4,          default: 0, null: false
    t.string   "seo_name",    limit: 255,                    null: false
    t.integer  "position",    limit: 4,          default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "desc",        limit: 4294967295
    t.boolean  "only_photos", limit: 1
  end

  add_index "categories", ["parent_id"], name: "index_categories_on_parent_id", using: :btree
  add_index "categories", ["position"], name: "index_categories_on_position", using: :btree
  add_index "categories", ["seo_name"], name: "index_categories_on_seo_name", using: :btree

  create_table "courses", force: :cascade do |t|
    t.string   "name",              limit: 255,   default: "",   null: false
    t.string   "course_type",       limit: 255,                  null: false
    t.boolean  "active",            limit: 1,     default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name",    limit: 255
    t.string   "logo_content_type", limit: 255
    t.integer  "logo_file_size",    limit: 4
    t.datetime "logo_updated_at"
    t.string   "seo",               limit: 255,   default: "",   null: false
    t.string   "title",             limit: 255
    t.text     "desc",              limit: 65535
    t.date     "date_start"
  end

  add_index "courses", ["course_type"], name: "index_courses_on_course_type", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name",       limit: 255, default: "",   null: false
    t.string   "group_type", limit: 255,                null: false
    t.boolean  "active",     limit: 1,   default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "course_id",  limit: 4
  end

  add_index "groups", ["group_type"], name: "index_groups_on_group_type", using: :btree

  create_table "lessons", force: :cascade do |t|
    t.string   "date",       limit: 255, default: "",   null: false
    t.string   "time",       limit: 255, default: "",   null: false
    t.integer  "course_id",  limit: 4,   default: 0,    null: false
    t.boolean  "active",     limit: 1,   default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lessons", ["course_id"], name: "index_lessons_on_course_id", using: :btree

  create_table "pages", force: :cascade do |t|
    t.integer  "category_id",       limit: 4,          default: 0,   null: false
    t.string   "seo_name",          limit: 255,                      null: false
    t.text     "desc",              limit: 4294967295
    t.text     "anons",             limit: 65535
    t.string   "title",             limit: 255,                      null: false
    t.string   "active",            limit: 255,        default: "",  null: false
    t.string   "author",            limit: 255,        default: "0", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",          limit: 4
    t.string   "logo_file_name",    limit: 255
    t.string   "logo_content_type", limit: 255
    t.integer  "logo_file_size",    limit: 4
    t.datetime "logo_updated_at"
  end

  add_index "pages", ["active"], name: "index_pages_on_active", using: :btree
  add_index "pages", ["category_id"], name: "index_pages_on_category_id", using: :btree
  add_index "pages", ["seo_name"], name: "index_pages_on_seo_name", using: :btree

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
    t.string   "name",              limit: 255, default: "",   null: false
    t.boolean  "is_in_school",      limit: 1,   default: true, null: false
    t.boolean  "is_in_club",        limit: 1,   default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name",    limit: 255
    t.string   "logo_content_type", limit: 255
    t.integer  "logo_file_size",    limit: 4
    t.datetime "logo_updated_at"
  end

  add_index "photos", ["is_in_club"], name: "index_photos_on_is_in_club", using: :btree
  add_index "photos", ["is_in_school"], name: "index_photos_on_is_in_school", using: :btree

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
    t.string   "name",             limit: 255
    t.string   "email",            limit: 255,                 null: false
    t.string   "phone",            limit: 255
    t.boolean  "active",           limit: 1,   default: true
    t.boolean  "school_subscribe", limit: 1,   default: false
    t.boolean  "club_subscribe",   limit: 1,   default: false
    t.boolean  "blog_subscribe",   limit: 1,   default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "course_id",        limit: 4
  end

  create_table "teachers", force: :cascade do |t|
    t.string   "name",              limit: 255,   default: "",   null: false
    t.text     "desc",              limit: 65535,                null: false
    t.boolean  "is_in_school",      limit: 1,     default: true, null: false
    t.boolean  "is_in_club",        limit: 1,     default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name",    limit: 255
    t.string   "logo_content_type", limit: 255
    t.integer  "logo_file_size",    limit: 4
    t.datetime "logo_updated_at"
  end

  add_index "teachers", ["is_in_club"], name: "index_teachers_on_is_in_club", using: :btree
  add_index "teachers", ["is_in_school"], name: "index_teachers_on_is_in_school", using: :btree

  create_table "upload_images", force: :cascade do |t|
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "file_file_name",    limit: 255
    t.string   "file_content_type", limit: 255
    t.integer  "file_file_size",    limit: 4
    t.datetime "file_updated_at"
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
