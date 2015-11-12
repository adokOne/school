class CreateBlog < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string   "title",   limit: 255,                    null: false
      t.integer  "parent_id",  limit: 4,          default: 0, null: false
      t.string   "seo_name",   limit: 255,                    null: false
      t.integer  "position",   limit: 4,          default: 0, null: false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.text     "desc",    limit: 4294967295
    end
    create_table :pages do |t|
      t.integer  "category_id", limit: 4,          default: 0,     null: false
      t.string   "seo_name",        limit: 255,                        null: false
      t.text     "desc",         limit: 4294967295
      t.text     "anons",        limit: 65535
      t.string   "title",        limit: 255,                        null: false
      t.string   "active",          limit: 255,          default: "", null: false
      t.integer  "author",       limit: 4,          default: 0,     null: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index(:categories, :parent_id)
    add_index(:categories, :position)
    add_index(:categories, :seo_name)
    add_index(:pages, :category_id)
    add_index(:pages, :seo_name)
    add_index(:pages, :active)
  end
end
