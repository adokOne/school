class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    t.string   "name",                    limit: 255
    t.string   "email",                   limit: 255,                 null: false, uniq: true
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
  end
end
