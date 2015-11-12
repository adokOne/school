class CreateSubscribers < ActiveRecord::Migration
  def change
    create_table :subscribers do |t|



    t.string   "name",                    limit: 255
    t.string   "email",                   limit: 255, null: false
    t.string   "phone",                   limit: 255
    t.boolean  "active",                  limit: 1,   default: true
    t.boolean  "school_subscribe",        limit: 1,   default: false
    t.boolean  "club_subscribe",          limit: 1,   default: false
    t.boolean  "blog_subscribe",          limit: 1,   default: false
    t.datetime "created_at"
    t.datetime "updated_at"

    end
  end
end
