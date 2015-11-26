class CreateBlogPage < ActiveRecord::Migration
  def change
    create_table :blog_pages do |t|

      t.string   "seo_name",          limit: 255,                      null: false
      t.text     "desc",              limit: 4294967295
      t.text     "anons",             limit: 65535
      t.string   "title",             limit: 255,                      null: false
      t.boolean  "active",            limit: 1,   default: true, null: false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "logo_file_name",    limit: 255
      t.string   "logo_content_type", limit: 255
      t.integer  "logo_file_size",    limit: 4
      t.datetime "logo_updated_at"

    end
  end
end
