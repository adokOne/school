class CreateAliases < ActiveRecord::Migration
  def change
    create_table :category_aliases do |t|
      t.integer :category_id
      t.string :seo_name
    end
    create_table :city_aliases do |t|
      t.integer :city_id
      t.string :seo_name
    end

    create_table :categories_pages do |t|
      t.integer :category_id
      t.integer :page_id
    end

    create_table :cities_pages do |t|
      t.integer :city_id
      t.integer :page_id
    end

  end
end
