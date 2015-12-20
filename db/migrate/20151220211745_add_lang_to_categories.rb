class AddLangToCategories < ActiveRecord::Migration
  def change
    rename_column :categories, :title, :title_ru
    rename_column :categories, :desc, :desc_ru

    %w{en ru uk}.each do |l|

      remove_column :categories, :"seo_text_#{l}"
    end
    add_column :categories, :"desc_uk", :text, limit:  4294967295
    add_column :categories, :"desc_en", :text, limit:  4294967295

    add_column :categories, :"title_en", :string
    add_column :categories, :"title_uk", :string
  end
end
